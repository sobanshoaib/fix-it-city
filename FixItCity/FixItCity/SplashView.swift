//
//  SplashScreen.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-05-23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                Text("Fix It City")
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    SplashView()
}
