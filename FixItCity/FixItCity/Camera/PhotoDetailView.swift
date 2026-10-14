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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Text("Looks good?")
                    .font(.system(size: 18, weight: .heavy).width(.expanded))
                    .foregroundStyle(.white)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(.white.opacity(0.1), in: Circle())
                    }
                    .accessibilityLabel("Back to camera")
                    Spacer()
                }
            }
            .frame(height: 44)
            
            Image(decorative: photo.capturedPhoto, scale: 1, orientation: .right)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            
            NavigationLink {
                FormView(photo: photo)
            } label: {
                HStack(spacing: 10) {
                    Text("Continue")
                    Image(systemName: "arrow.right")
                }
                .font(.system(size: 17, weight: .heavy))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(Color.fixRed, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color.fixRed.opacity(0.35), radius: 14, y: 10)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.camBlack.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    if let cgImage = UIImage(systemName: "photo")?.cgImage {
            NavigationStack {
                PhotoDetailView(photo: CapturedPhoto(capturedPhoto: cgImage, location: nil))
            }
        }
}


