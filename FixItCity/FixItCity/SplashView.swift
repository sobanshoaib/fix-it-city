//
//  SplashScreen.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-05-23.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Text("Fix It City")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink {
                        CameraView()
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            print("[SplashView] Splash view appeared")
        }
    }
}

#Preview {
    SplashView()
}
