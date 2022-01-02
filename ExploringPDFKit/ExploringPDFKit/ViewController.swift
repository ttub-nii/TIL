//
//  ViewController.swift
//  ExploringPDFKit
//
//  Created by toby.with on 2022/01/02.
//

import PDFKit
import UIKit

class ViewController: UIViewController, PDFViewDelegate {

    // Views
    let pdfView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        
        // Document
        guard let url = Bundle.main.url(forResource: "416_understanding_swift_performance", withExtension: "pdf") else {
            return
        }
        
        guard let document = PDFDocument(url: url) else {
            return
        }
        
        pdfView.document = document
        pdfView.delegate = self
        
        // Create new document
        let newDocument = PDFDocument()
        guard let page = PDFPage(image: UIImage(systemName: "house")!) else {
            return
        }
        
        newDocument.insert(page, at: 0)
//        pdfView.document = newDocument
//         pdfView.visiblePages
//         pdfView.displaysPageBreaks = true
        pdfView.autoScales = true // 화면에 알맞게 조정
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.bounds
    }

}
