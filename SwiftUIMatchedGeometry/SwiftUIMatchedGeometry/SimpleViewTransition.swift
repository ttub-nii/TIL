//
//  SimpleViewTransition.swift
//  SwiftUIMatchedGeometry
//
//  Created by Simon Ng on 23/9/2020.
//

import SwiftUI

struct SimpleViewTransition: View {
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

struct SimpleViewTransition_Previews: PreviewProvider {
    static var previews: some View {
        SimpleViewTransition()
    }
}
