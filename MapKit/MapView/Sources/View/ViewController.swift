//
//  ViewController.swift
//  MapView
//
//  Created by 황수빈 on 11/06/2019.
//  Copyright © 2019 황수빈. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var map: MKMapView!
    @IBOutlet var alternateSwitch: UISwitch!
    @IBOutlet var labelAlternate: UILabel!
    
    // 사용자가 선택한 Cell 인덱스를 받아옴
    var selectedIndex: Int? = nil
    // Table View에서 선택한 대학 객체를 전달받기 위함
    var univ: University? = nil
    // annotation을 찍기 위한 변수
    var universityAnnotation: University? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = selectedIndex {
            map.setRegion(MKCoordinateRegion(
                center: (self.univ?.coordinate)!,
                span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)),
                animated: true)
            // let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
            // setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: animated)
        }
        
        // 기존의 맵에 annotation이 있었다면 삭제
        if let annotation = universityAnnotation {
            self.map.removeAnnotation(annotation)
        }
        // 새로운 annotation 위치가 있다면 추가
        if let annotation = univ {
            self.universityAnnotation = annotation
            self.map.addAnnotation(self.universityAnnotation!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUnivView" {
            if let destVC = segue.destination as? UnivTableViewController {
                destVC.mainVC = self
            }
        }
    }

    @IBAction func updateMap(_ sender: UISegmentedControl) {
        var alternate: Int = 0
        if alternateSwitch.isOn { alternate = 3 }
        labelAlternate.text = ""
        switch sender.selectedSegmentIndex + alternate {
        case 0:
            self.map.mapType = MKMapType.standard
        case 1:
            self.map.mapType = MKMapType.satellite
        case 2:
            self.map.mapType = MKMapType.hybrid
        case 3:
            self.map.mapType = MKMapType.satelliteFlyover
            labelAlternate.text = "Satellite Flyover"
        case 4:
            self.map.mapType = MKMapType.hybridFlyover
            labelAlternate.text = "Hybrid Flyover"
        default:
            self.map.mapType = MKMapType.mutedStandard
            labelAlternate.text = "Muted Standard"
        }
    }
    
}

