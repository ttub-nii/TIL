//
//  SecondGoalView.swift
//  CardAnimation
//
//  Created by toby.with on 2022/01/29.
//

import SwiftUI

struct SecondGoalView: View {
    var goal: Goal
    @State var content: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // 수정 막았다 풀었다 어떻게 하지
            Text(goal.content ?? "default value")
                .bold()
                .font(.title)
            TextField("Type something...", text: $content)
            TextField("Type something...", text: $content)
            TextField("Type something...", text: $content)
            TextField("Type something...", text: $content)
        }
        .padding(15)
        .foregroundColor(.white)
        .border(Color.white, width: 1)
        .background(goal.color)
        .cornerRadius(18)
    }
}

struct SecondGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SecondGoalView(goal: testGoals[0])
            .previewLayout(.sizeThatFits)
    }
}
