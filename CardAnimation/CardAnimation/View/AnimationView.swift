//
//  AnimationView.swift
//  CardAnimation
//
//  Created by toby.with on 2022/01/29.
//

import SwiftUI

struct AnimationView: View {
    @State private var expand = false
    @Namespace private var cardTransition
    
    var body: some View {
        // Display an article view with smaller image
        if !expand {
            FirstAnimationView(expand: $expand, cardTransition: cardTransition)
        } else {
        // Display the article view in a full screen
            SecondAnimationView(expand: $expand, cardTransition: cardTransition)
        }
    }
}

struct FirstAnimationView: View {
    @Binding var expand: Bool
    var cardTransition: Namespace.ID
    
    @State var goals: [Goal] = testGoals
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                ForEach(goals.reversed()) { goal in
                    FirstGoalView(goal: goal)
                        .offset(self.offset(for: goal))
                        .matchedGeometryEffect(id: "\(goal)", in: cardTransition)
                        .animation(.interactiveSpring())
                        .onTapGesture {
                            self.expand.toggle()
                        }
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
}

struct SecondAnimationView: View {
    @Binding var expand: Bool
    var cardTransition: Namespace.ID
    
    @State var goals: [Goal] = testGoals
    
    var body: some View {
        ZStack {
            ForEach(goals.reversed()) { goal in
                SecondGoalView(goal: goal)
                    .offset(self.offset(for: goal))
                    .matchedGeometryEffect(id: "\(goal)", in: cardTransition)
                    .animation(.interactiveSpring())
                    .onTapGesture {
                        self.expand.toggle()
                    }
            }
        }
        .offset(x: -30, y: 70)
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
        
        return CGSize(width: 20 * CGFloat(cardIndex), height: -50 * CGFloat(cardIndex))
    }
}

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}
