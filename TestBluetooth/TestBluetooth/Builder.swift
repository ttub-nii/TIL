//
//  Builder.swift
//  TestBluetooth
//
//  Created by toby.with on 2022/02/08.
//

import CoreBluetooth
import Foundation

struct AttBuilder {
    fileprivate struct k {
        static var ServiceUUID = CBUUID(string: "cf30bf00-55c0-44c9-8c9b-e0465fc2f196")
        static var CharUUID = CBUUID(string: "cf30bf01-55c0-44c9-8c9b-e0465fc2f196")
    }

    func build() {
        // build up 할 때는 mutable 사용
        let service = CBMutableService(type: k.ServiceUUID, primary: true)
        let char = CBMutableCharacteristic(type: k.CharUUID,
                                           properties: [.read],
                                           value: nil,
                                           permissions: [.readable])
        service.characteristics = [char] // buildup 끝
        
        // MARK: - subservice를 사용하면 구조가..
        // service
        // <- subservice
        // <- characteristic
    }
    
}

struct AdvertisementDataBuilder {
    fileprivate struct k {
        static var ServiceUUID = CBUUID(string: "cf30bf00-55c0-44c9-8c9b-e0465fc2f196")
        static var CharUUID = CBUUID(string: "cf30bf01-55c0-44c9-8c9b-e0465fc2f196")
    }

    func build() {
        let advertiseData: [String: Any] = [CBAdvertisementDataServiceUUIDsKey: [k.ServiceUUID],
                                            CBAdvertisementDataLocalNameKey: "TestDevice"]
    }
}
