//
//  LandmarkDetail.swift
//  WatchLandmarks Extension
//
//  Created by toby.with on 2022/01/20.
//

import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var modelData: ModelData
    var landmark: Landmark

    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    var body: some View {
        Text("Hello, World!")
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        return LandmarkDetail(landmark: modelData.landmarks[0])
            .environmentObject(modelData)
    }
}
