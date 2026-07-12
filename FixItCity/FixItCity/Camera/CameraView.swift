//
//  CameraView.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-05-24.
//

import SwiftUI
import CoreImage

struct CameraView: View {
    @State private var cameraVM = CameraViewModel()
    
    var body: some View {
        ZStack {
            if let image = cameraVM.currentFrame {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading camera...")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
            }
            VStack {
                Spacer()
                Button{
                    cameraVM.takePhoto()
                } label: {
                    Circle()
                        .fill(.white)
                        .frame(width: 80, height: 80)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            cameraVM.startCameraStream()
        }
    }
}

#Preview {
    CameraView()
}
