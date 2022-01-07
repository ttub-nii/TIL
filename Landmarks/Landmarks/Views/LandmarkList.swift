//
//  LandmarkList.swift
//  Landmarks
//
//  Created by toby.with on 2022/01/07.
//

import SwiftUI

struct LandmarkList: View {
    var body: some View {
        /*
        // MARK: static list
        List {
            LandmarkRow(landmark: landmarks[0])
            LandmarkRow(landmark: landmarks[1])
        }
        
        // MARK: dynamic list
        // 1. passing along with data a key path to a property
        List(landmarks, id: \.id) { landmark in
            LandmarkRow(landmark: landmark)
        }
        */
        
        // 2. making data type conform to the Identifiable protocol
        NavigationView {
            List(landmarks) { landmark in
                NavigationLink(destination: LandmarkDetail()) {
                    LandmarkRow(landmark: landmark)
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
