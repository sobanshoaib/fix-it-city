//
//  PhotoDetailView.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-07-18.
//

import SwiftUI
import CoreImage

struct PhotoDetailView: View {
    let photo: CapturedPhoto
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(decorative: photo.capturedPhoto, scale: 1)
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(90))
                .ignoresSafeArea()
                .background(Color.black)
            
            if let address = photo.location?.address {
                Text(address)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.bottom, 30)
            }
            
            NavigationLink {
                FormView()
            } label: {
                  Text("Next")
                      .font(.headline)
                      .foregroundColor(.green)
                      .frame(maxWidth: .infinity)
                      .padding()
                      .background(Color.white)
                      .cornerRadius(8)
            }
        }
        
    }
}

#Preview {
    if let cgImage = UIImage(systemName: "photo")?.cgImage {
        PhotoDetailView(photo: CapturedPhoto(capturedPhoto: cgImage, location: nil))
    }
}


