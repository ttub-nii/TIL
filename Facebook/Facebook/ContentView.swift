//
//  ContentView.swift
//  Facebook
//
//  Created by toby.with on 2022/01/03.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var text: String
    
    let stories = ["story1", "story2", "story3", "story4", "story5"]
    
    let facebookBlue = UIColor(red: 23/255.0,
                               green: 120/255.0,
                               blue: 242/255.0,
                               alpha: 1)
    
    var body: some View {
        VStack {
            HStack {
                Text("facebook")
                    .foregroundColor(Color(facebookBlue))
                    .font(.system(size: 48, weight: .bold, design: .default))
                
                Spacer()
                
                Image(systemName: "person.circle")
                    .resizable()
                    .foregroundColor(Color(.secondaryLabel))
                    .frame(width: 45, height: 45, alignment: .center)
            }
            .padding()
            
            TextField("Search...", text: $text)
                .padding(7)
                .background(Color(.systemGray5))
                .cornerRadius(13)
                .padding(.horizontal, 15)

            ZStack {
                Color(.secondarySystemBackground)
                
                ScrollView(.vertical) {
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 3) {
                                ForEach(stories, id: \.self) { name in
                                    Image(name)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 140, height: 200, alignment: .center)
                                        .background(Color.red)
                                        .clipped()
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(text: .constant(""))
    }
}
