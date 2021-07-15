//
//  String+Regex.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/14.
//

import Foundation

extension String {
    func isValidPhone() -> Bool {
        let regex = "^[0-9]{11}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return phoneTest.evaluate(with: self)
    }
    
    func isValidResident() -> Bool {
        let regex = "^\\d{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|[3][01])[1-4]"
        let residentTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return residentTest.evaluate(with: self)
    }
    
    func isValidNumber() -> Bool {
        let regex = "^[0-9]{6}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return phoneTest.evaluate(with: self)
    }
}
