//
//  Profile.swift
//  Landmarks
//
//  Created by toby.with on 2022/01/13.
//

import Foundation

struct Profile {
    var username: String
    var prefersNotifications = true
    var seasonalPhoto = Season.winter
    var goalDate = Date()
    
    static let `default` = Profile(username: "ttub_nii")
    
    enum Season: String, CaseIterable, Identifiable {
        case spring = "🥱"
        case summer = "🥵"
        case autumn = "🙃"
        case winter = "🥶"
        
        var id: String { rawValue }
    }
}
