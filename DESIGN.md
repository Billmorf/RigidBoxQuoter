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
