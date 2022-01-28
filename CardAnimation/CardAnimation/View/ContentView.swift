//
//  ContentView.swift
//  CardAnimation
//
//  Created by toby.with on 2022/01/28.
//

import SwiftUI

struct ContentView: View {
//    var goals : [Goal]
    @State var goals: [Goal] = testGoals
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                ForEach(goals.reversed()) { goal in
                    GoalView(goal: goal)
                        .offset(self.offset(for: goal))
                        .transition(AnyTransition.slide.combined(with: .move(edge: .leading)).combined(with: .opacity))
                        .animation(self.transitionAnimation(for: goal))
                }
            }
        }
    }

    private func index(for card: Goal) -> Int? {
        guard let index = goals.firstIndex(where: { $0.id == card.id }) else {
            return nil
        }
        
        return index
    }
    
    private func offset(for card: Goal) -> CGSize {
        guard let cardIndex = index(for: card) else {
            return CGSize()
        }
        
        return CGSize(width: 0, height: -50 * CGFloat(cardIndex))
    }
    
    private func transitionAnimation(for card: Goal) -> Animation {
        var delay = 0.0
        
        if let index = index(for: card) {
            delay = Double(goals.count - index) * 0.1
        }
        
        return Animation.spring(response: 0.1, dampingFraction: 0.8, blendDuration: 0.02).delay(delay)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(goals: testGoals)
    }
}
