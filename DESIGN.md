# Design Decisions

This document records key architectural and domain-logic decisions made during development.

## Domain Model

### RawMaterial
Represents a raw material used in box production (cardboard, covering paper, glue, etc.).

| Field | Type | Notes |
|---|---|---|
| name | String | e.g. "Cardboard 2mm" |
| unit | MaterialUnit | see enum below |
| pricePerUnit | Double | price per unit |
| sheetWidth | Double? | only relevant when unit == .sheet |
| sheetHeight | Double? | only relevant when unit == .sheet |
| lastUpdated | Date | updated whenever price changes |

### MaterialUnit (enum)
Materials are measured in one of: sheet, kilogram, piece, squareMeter.
Sheet-based materials (cardboard, covering paper) carry their own sheet dimensions,
since different suppliers/types use different sheet sizes (e.g. 75x105cm).

## Box Construction Formulas

A rigid box consists of a **base** and a **lid**, each built from two layers:
a structural board and a covering (wrapping) paper.

### Board wrap formula (applies to both base and lid)
### Lid dimensions (derived automatically from base)
### Covering paper formula
The covering paper wraps around the outside of the board and needs extra
allowance to fold over the edges:
This gives 4 distinct pieces per box: board-base, board-lid, covering-base, covering-lid.
Each piece is matched against its own RawMaterial's sheet dimensions.

## Sheet Fitting Algorithm

To determine how many pieces fit into one raw material sheet, a grid-fit
approach is used rather than simple area division, since area division
overestimates how many pieces actually fit in practice.
This does not implement true cutting-stock optimization (mixed orientations
within the same sheet); it picks the better of the two uniform orientations,
which is accurate enough for this use case.

## Architecture

- **Pattern**: MVVM
- **Persistence**: SwiftData
- **Pricing logic**: isolated in a plain `PricingCalculator` type with no
  SwiftUI/SwiftData dependencies, so it can be unit tested independently
  of the UI and persistence layers.


## Pricing Model

`PricingCalculator.calculateOffer` combines material, labor and tooling costs
into an offer total. Every step is a pure function with unit tests.

### Material cost
Each of the four pieces is fitted separately onto sheets of its own material:
board pieces use the structural material, covering pieces use the covering paper.

```
sheetsNeeded = ceil(quantity / piecesPerSheet)
materialCost = sheetsNeeded × pricePerSheet      (summed over the 4 pieces)
```

### Labor cost
```
laborCost = (laborMinutes × quantity / 60) × hourlyRate
```
`laborMinutes` belongs to the box template (time to assemble one box), while
`hourlyRate` is a single app-wide setting.

### Tooling (mold) cost
A mold is a one-off cost: it is added once per offer, regardless of quantity,
and only when the user enables it for that offer.

### Totals
```
subTotal    = materialCost + laborCost + moldCost
total       = subTotal × (1 + marginPercent / 100)
profit      = total - subTotal
costPerUnit = total / quantity
```
The margin is chosen per offer, not stored globally, because it varies by customer.

## Data Decisions

### Offers are snapshots
An `Offer` stores the calculated numbers and the template name as plain values,
with no relationships to `RawMaterial` or `BoxTemplate`. A quote given to a
customer is a commitment, so later price changes or deleted templates must not
alter it. The cost of this choice is that an old offer cannot be recalculated.

### Templates reference materials
A `BoxTemplate` points to live `RawMaterial` objects (structural and covering).
Deleting a material that a template uses would leave a dangling reference and
crash at runtime, so the UI blocks that deletion with an explanatory alert.

### Settings are stored, not typed per offer
The hourly rate is saved once (`AppSettings`) and read by every offer.

## Client-facing vs internal data

The offer detail screen shows the full internal breakdown (materials, labor,
tooling, margin, profit). The exported PDF is addressed to the customer and
shows only the customer name, box, quantity, price per box and totals,
never margin or internal costs.

### PDF generation
The PDF is rendered from a plain SwiftUI view (`OfferPrintableContent`) using
`ImageRenderer`. The on-screen preview wraps the same content in a
`NavigationStack` for its Back button, but that wrapper cannot be rendered
into a PDF, so the printable content is kept separate from the navigation.
The company name, payment/delivery terms, validity period and VAT rate are
placeholders defined at the top of that file. VAT is applied on top of
`total`, so prices are assumed to be entered without VAT.

## Technical Notes

- **Decimal input:** Greek keyboards produce a comma. Numeric text fields are
  parsed with `String.asDouble`, which accepts both `0,75` and `0.75`.
- **Floating point:** tests compare money values with a small tolerance
  instead of `==`, since results such as `149 × 1.2` are not exactly representable.
- **Concurrency:** the calculator and its value types are `nonisolated` so they
  can be tested and called outside the main actor. Views and view models
  remain on the main actor.
- **Testing:** unit tests use Swift Testing and cover the piece dimensions,
  sheet fitting, sheet count, material cost, the full offer calculation and
  decimal parsing.

## Known Limitations

- **Known issue:** if a template's pieces do not fit on its selected material
  sheets, quoting with that template crashes (division by zero in the sheet
  count). A fit check before calculating is planned.
- Sheet fitting picks the better of two uniform orientations; it does not
  mix orientations on one sheet (no true cutting-stock optimization).
- Single currency (EUR); the currency is not configurable.
- Box templates and offers can be created and deleted but not edited.
- The PDF is a single A4 page.