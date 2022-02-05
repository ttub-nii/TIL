//
//  ContentView.swift
//  SwiftUIMatchedGeometry
//
//  Created by Simon Ng on 23/9/2020.
//

import SwiftUI

struct ContentView: View {
       
    var body: some View {
        HeroAnimationView()
    }
}

struct CircleTransitionView: View {
    @State private var expand = false
    
    @Namespace private var shapeTransition
    
    var body: some View {
        if expand {
            
            // Final State
            Circle()
                .fill(Color.green)
                .matchedGeometryEffect(id: "circle", in: shapeTransition)
                .frame(width: 300, height: 300)
                .offset(y: -200)
                .animation(.default)
                .onTapGesture {
                    self.expand.toggle()
                }
            
        } else {
            
            // Start State
            Circle()
                .fill(Color.green)
                .matchedGeometryEffect(id: "circle", in: shapeTransition)
                .frame(width: 150, height: 150)
                .offset(y: 0)
                .animation(.default)
                .onTapGesture {
                    self.expand.toggle()
                }
        }
    }
}

struct RoundedRectangleTransitionView: View {
    
    @State private var expand = false
    
    @Namespace private var shapeTransition
    
    var body: some View {
        VStack {
            if expand {
                
                // Rounded Rectangle
                Spacer()
                
                RoundedRectangle(cornerRadius: 50.0)
                    .matchedGeometryEffect(id: "circle", in: shapeTransition)
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 300)
                    .padding()
                    .foregroundColor(Color(.systemGreen))
                    .animation(.easeIn)
                    .onTapGesture {
                        expand.toggle()
                    }

            } else {
                
                // Circle
                RoundedRectangle(cornerRadius: 50.0)
                    .matchedGeometryEffect(id: "circle", in: shapeTransition)
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(.systemOrange))
                    .animation(.easeIn)
                    .onTapGesture {
                        expand.toggle()
                    }
                
                Spacer()
            }
        }
    }
}

struct SwapTransitionView: View {
    
    @State private var swap = false
    
    @Namespace private var dotTransition
    
    var body: some View {
        if swap {
            
            // After swap
            // Green dot on the left, Orange dot on the right

            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 30, height: 30)
                    .matchedGeometryEffect(id: "greenCircle", in: dotTransition)
                
                Spacer()
                
                Circle()
                    .fill(Color.orange)
                    .frame(width: 30, height: 30)
                    .matchedGeometryEffect(id: "orangeCircle", in: dotTransition)
            }
            .frame(width: 100)
            .animation(.linear)
            .onTapGesture {
                swap.toggle()
            }
            
        } else {
            
            // Start state
            // Orange dot on the left, Green dot on the right
            
            HStack {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 30, height: 30)
                    .matchedGeometryEffect(id: "orangeCircle", in: dotTransition)
                
                Spacer()
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 30, height: 30)
                    .matchedGeometryEffect(id: "greenCircle", in: dotTransition)
            }
            .frame(width: 100)
            .animation(.linear)
            .onTapGesture {
                swap.toggle()
            }
        }

    }
}

struct SwapPhotoView: View {
    
    @State private var swap = false
    
    @Namespace private var photoTransition
    
    var body: some View {
        if swap {
            HStack {
                Image("espresso")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 200)
                    .matchedGeometryEffect(id: "photo1", in: photoTransition)
                    .clipped()
                
                
                Image(systemName: "arrow.right.arrow.left")
                    .font(.system(size: 40))
                    .onTapGesture {
                        withAnimation(.linear) {
                            swap.toggle()
                        }
                    }
                
                Image("latte")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 200)
                    .matchedGeometryEffect(id: "photo2", in: photoTransition)
                    .clipped()
                
            }
            
            
        } else {
            HStack {
                Image("latte")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 200)
                    .matchedGeometryEffect(id: "photo2", in: photoTransition)
                    .clipped()
                
                
                Image(systemName: "arrow.right.arrow.left")
                    .font(.system(size: 40))
                    .onTapGesture {
                        withAnimation(.linear) {
                            swap.toggle()
                        }
                    }
                
                Image("espresso")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 200)
                    .matchedGeometryEffect(id: "photo1", in: photoTransition)
                    .clipped()
                
            }
            
        }
    }
}

struct FullScreenTransitionView: View {
    @State private var expand = false
    
    @Namespace private var shapeTransition
    
    var body: some View {
        
        if expand {
            
            RoundedRectangle(cornerRadius: 20.0)
                .matchedGeometryEffect(id: "rectangle", in: shapeTransition)
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Color(.systemGreen))
                .animation(.easeIn)
                .onTapGesture {
                    expand.toggle()
                }
                .edgesIgnoringSafeArea(.all)
            
        } else {
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 50.0)
                .matchedGeometryEffect(id: "rectangle", in: shapeTransition)
                .frame(width: 100, height: 100)
                .foregroundColor(Color(.systemOrange))
                .animation(.easeIn)
                .onTapGesture {
                    expand.toggle()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            ZStack {
//                CircleTransitionView()
//            }
//            .previewDisplayName("Circle")
//
//            ZStack {
//                RoundedRectangleTransitionView()
//            }
//            .previewDisplayName("Rounded Rectangle")
//
//            ZStack {
//                SwapTransitionView()
//            }
//            .previewDisplayName("Swap Circles")
//
//            ZStack {
//                SwapPhotoView()
//            }
//            .previewDisplayName("Swap Photos")
//
//            VStack {
//                FullScreenTransitionView()
//            }
//            .previewDisplayName("Full Screen Transition")
            
            ZStack {
                HeroAnimationView()
            }
            .previewDisplayName("Hero Animation")
        }
    }
}

struct HeroAnimationView: View {
    @State private var showDetail = false
    
    @Namespace private var articleTransition
    
    var body: some View {
        
        // Display an article view with smaller image
        if !showDetail {
            FirstAnimationView(showDetail: $showDetail, articleTransition: articleTransition)
        }
        
        // Display the article view in a full screen
        if showDetail {
            SecondAnimationView(showDetail: $showDetail, articleTransition: articleTransition)
        }
        
    }
}

struct ArticleExcerptView: View {
    
    @Binding var showDetail: Bool
    
    var articleTransition: Namespace.ID
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Image("latte")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 200)
                    .matchedGeometryEffect(id: "image", in: articleTransition)
                    .cornerRadius(10)
                    .animation(.interactiveSpring())
                    .padding()
                    .onTapGesture {
                        showDetail.toggle()
                    }
                
                Text("The Watertower is a full-service restaurant/cafe located in the Sweet Auburn District of Atlanta.")
                    .matchedGeometryEffect(id: "text", in: articleTransition)
                    .animation(nil)
                    .padding(.horizontal)
            }
        }
    }
}

struct ArticleDetailView: View {
    @Binding var showDetail: Bool
    
    var articleTransition: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack {
                Image("latte")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 400)
                    .clipped()
                    .matchedGeometryEffect(id: "image", in: articleTransition)
                    .animation(.interactiveSpring())
                    .onTapGesture {
                        showDetail.toggle()
                    }
                
                Text("The Watertower is a full-service restaurant/cafe located in the Sweet Auburn District of Atlanta. The restaurant features a full menu of moderately priced \"comfort\" food influenced by African and French cooking traditions, but based upon time honored recipes from around the world. The cafe section of The Watertower features a coffeehouse with a dessert bar, magazines, and space for live performers.\n\nThe Watertower will be owned and operated by The Watertower LLC, a Georgia limited liability corporation managed by David N. Patton IV, a resident of the Empowerment Zone. The members of the LLC are David N. Patton IV (80%) and the Historic District Development Corporation (20%).\n\nThis business plan offers financial institutions an opportunity to review our vision and strategic focus. It also provides a step-by-step plan for the business start-up, establishing favorable sales numbers, gross margin, and profitability.\n\nThis plan includes chapters on the company, products and services, market focus, action plans and forecasts, management team, and financial plan.")
                    .matchedGeometryEffect(id: "text", in: articleTransition)
                    .animation(.easeOut)
                    .padding(.all, 20)
                
                Spacer()
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct FirstAnimationView: View {
    @Binding var showDetail: Bool
    var articleTransition: Namespace.ID
    
    @State var goals: [Goal] = testGoals
    
    var body: some View {
        Color("BackgroundColor")
            .ignoresSafeArea()
        
        ScrollView(.vertical) {
            FirstGoalView(goal: goals[0])
                .matchedGeometryEffect(id: "goal1", in: articleTransition)
            FirstGoalView(goal: goals[1])
                .matchedGeometryEffect(id: "goal2", in: articleTransition)
            FirstGoalView(goal: goals[2])
                .matchedGeometryEffect(id: "goal3", in: articleTransition)
            FirstGoalView(goal: goals[3])
                .matchedGeometryEffect(id: "goal4", in: articleTransition)
        }
        .padding([.leading, .trailing], 20)
        .animation(.easeOut)
        .onTapGesture {
            showDetail.toggle()
        }
//        VStack {
//            Spacer()
//            ZStack {
//                ForEach(goals.reversed()) { goal in
//                    FirstGoalView(goal: goal)
//                        .offset(self.offset(for: goal))
//                        .matchedGeometryEffect(id: "\(goal.id)", in: articleTransition)
//                        .animation(.easeIn)
//                        .onTapGesture {
//                            showDetail.toggle()
//                        }
//                }
//            }
//        }
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
    @Binding var showDetail: Bool
    var articleTransition: Namespace.ID
    
    @State var goals: [Goal] = testGoals
    
    var body: some View {
        Color("BackgroundColor")
            .ignoresSafeArea()
        
        HStack {
            VStack {
                SecondGoalView(goal: goals[0])
                    .matchedGeometryEffect(id: "goal1", in: articleTransition)
                SecondGoalView(goal: goals[3])
                    .matchedGeometryEffect(id: "goal4", in: articleTransition)
            }
            
            VStack {
                SecondGoalView(goal: goals[1])
                    .matchedGeometryEffect(id: "goal2", in: articleTransition)
                SecondGoalView(goal: goals[2])
                    .matchedGeometryEffect(id: "goal3", in: articleTransition)
            }
        }
        .animation(.easeOut)
        .onTapGesture {
            showDetail.toggle()
        }
        
//        ZStack {
//            ForEach(goals.reversed()) { goal in
//                SecondGoalView(goal: goal)
//                    .offset(self.offset(for: goal))
//                    .matchedGeometryEffect(id: "\(goal.id)", in: articleTransition)
//                    .animation(.easeOut)
//                    .onTapGesture {
//                        showDetail.toggle()
//                    }
//            }
//        }
//        .offset(x: -30, y: 70)
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
