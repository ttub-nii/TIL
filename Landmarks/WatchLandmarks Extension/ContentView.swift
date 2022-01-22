//
//  ContentView.swift
//  WatchLandmarks Extension
//
//  Created by toby.with on 2022/01/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
