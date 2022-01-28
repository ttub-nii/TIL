//
//  CardView.swift
//  CardAnimation
//
//  Created by toby.with on 2022/01/28.
//

import SwiftUI

struct CardView: View {
    @State var goal: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("세부목표")
            Spacer()
            TextField("", text: $goal)
        }
        .padding(20)
        .frame(height: 130, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(Color.blue)
        .cornerRadius(10)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .previewLayout(.sizeThatFits)
    }
}
