//
//  Goal.swift
//  CardAnimation
//
//  Created by toby.with on 2022/01/28.
//

import Foundation
import SwiftUI

enum GoalType: String {
    case large
    case medium
    case small
}

struct Goal: Identifiable {
    var id = UUID()
    var title: String
    var content: String?
    var color: Color?
    var type: GoalType
}

let testGoals = [
    Goal(title: "세부목표1", color: .red, type: .small),
    Goal(title: "세부목표2", color: .yellow, type: .small),
    Goal(title: "세부목표3", color: .green, type: .small),
    Goal(title: "세부목표4", color: .blue, type: .small)
]
