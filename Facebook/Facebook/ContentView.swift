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
                        
                        FBPost(name: "Mark Zuckerberg",
                               post: "Hey guys I made this cool website called the facebook to see if I'm cool or not!",
                               imageName: "person1")
                        Spacer()
                        FBPost(name: "Jeff Bezos",
                               post: "You'll all see once I take over the world with Amazon",
                               imageName: "person2")
                        Spacer()
                        FBPost(name: "Bill Gates",
                               post: "who cares - I made windows!",
                               imageName: "person3")
                        Spacer()
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct FBPost: View {
    
    @State var isLiked: Bool = false
    
    let name: String
    let post: String
    let imageName: String
    
    var body: some View {
        VStack {
            HStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(25)
                
                VStack {
                    HStack {
                        Text(name)
                            .foregroundColor(.blue)
                            .font(.system(size: 18, weight: .semibold, design: .default))
                        Spacer()
                    }
                    
                    HStack {
                        Text("12 minutes ago")
                            .foregroundColor(Color(.secondaryLabel))
                        Spacer()
                    }
                }
                Spacer()
            }
            Spacer()
            
            HStack {
                Text(post)
                    .font(.system(size: 24, weight: .regular, design: .default))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    isLiked.toggle()
                }, label: {
                    Text(isLiked ? "Liked" : "Like  ")
                })
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Text("Comment")
                })
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Text("Share")
                })
            }
            .padding()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(7)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(text: .constant(""))
    }
}
