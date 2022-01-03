//
//  ContentView.swift
//  Facebook
//
//  Created by toby.with on 2022/01/03.
//

import SwiftUI

struct ContentView: View {
    
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
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
