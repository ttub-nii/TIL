//
//  UICollectionViewCell+reuseIdentifier.swift
//  TodayHouse
//
//  Created by toby.with on 2021/07/29.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
