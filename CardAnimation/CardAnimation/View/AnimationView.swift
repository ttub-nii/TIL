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
        ScrollView(.vertical) {
            FirstGoalView(goal: goals[0])
                .matchedGeometryEffect(id: "goal0", in: cardTransition)
            FirstGoalView(goal: goals[1])
                .matchedGeometryEffect(id: "goal1", in: cardTransition)
            FirstGoalView(goal: goals[2])
                .matchedGeometryEffect(id: "goal2", in: cardTransition)
            FirstGoalView(goal: goals[3])
                .matchedGeometryEffect(id: "goal3", in: cardTransition)
        }
        .animation(.easeInOut)
        .onTapGesture {
            expand.toggle()
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
        HStack {
            VStack {
                SecondGoalView(goal: goals[0])
                    .matchedGeometryEffect(id: "goal0", in: cardTransition)
                SecondGoalView(goal: goals[3])
                    .matchedGeometryEffect(id: "goal3", in: cardTransition)
            }
            
            VStack {
                SecondGoalView(goal: goals[1])
                    .matchedGeometryEffect(id: "goal1", in: cardTransition)
                SecondGoalView(goal: goals[2])
                    .matchedGeometryEffect(id: "goal2", in: cardTransition)
            }
//            .aspectRatio(contentMode: .fit)
        }
        .animation(.easeInOut)
        .onTapGesture {
            expand.toggle()
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
        
        return CGSize(width: 20 * CGFloat(cardIndex), height: -50 * CGFloat(cardIndex))
    }
}

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}
