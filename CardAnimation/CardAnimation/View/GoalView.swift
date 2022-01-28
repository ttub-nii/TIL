//
//  GoalView.swift
//  CardAnimation
//
//  Created by toby.with on 2022/01/28.
//

import SwiftUI

struct GoalView: View {
    var goal: Goal
    @State var content: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(goal.title)")
            TextField("", text: $content)
                .frame(height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .padding(15)
        .frame(height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(goal.color)
        .cornerRadius(18)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(goal: testGoals[0])
            .previewLayout(.sizeThatFits)
    }
}
