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
            
            VStack {
                HStack {
                    Spacer()
                    
                    if let captured = cameraVM.capturedPhoto {
                        NavigationLink {
                            PhotoDetailView(photo: captured)
                        } label: {
                            Image(decorative: captured.capturedPhoto, scale: 1)
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(90))
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.8), lineWidth: 1))
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
                Spacer()
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
