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
            HStack {
                TextField("Type something...", text: $content)
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.white)
//                    .padding(5)
                TextField("Type something...", text: $content)
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.white)
            }
            HStack {
                TextField("Type something...", text: $content)
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.white)
                TextField("Type something...", text: $content)
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.white)
            }
        }
//        .padding(15)
        .frame(width: 250, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
