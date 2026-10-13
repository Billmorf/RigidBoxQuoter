//
//  PDFGenerator.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 29/8/26.
//

import Foundation
import SwiftUI

enum PDFGenerator {
    @MainActor
    static func generate(for offer: Offer) -> URL? {
        let view = OfferPrintableContent(offer: offer)
        let renderer = ImageRenderer(content: view)
        
        let pageSize = CGSize(width: 595, height: 842)
        renderer.proposedSize = .init(pageSize)
        
        let url = URL.documentsDirectory.appending(path: "Offer-\(offer.clientName).pdf")
        
        renderer.render { size, renderContext in
            var mediaBox = CGRect(origin: .zero, size: pageSize)
            guard let pdfContext = CGContext(url as CFURL, mediaBox: &mediaBox, nil) else { return }
            pdfContext.beginPDFPage(nil)
            renderContext(pdfContext)
            pdfContext.endPDFPage()
            pdfContext.closePDF()
        }
        
        return url
        
    }
}
