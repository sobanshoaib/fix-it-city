//
//  PhotoDetailView.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-07-18.
//

import SwiftUI
import CoreImage

struct PhotoDetailView: View {
    let image: CGImage
    
    var body: some View {
        Image(decorative: image, scale: 1)
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(90))
            .ignoresSafeArea()
            .background(Color.black)
        
    }
}

#Preview {
    if let cgImage = UIImage(systemName: "photo")?.cgImage {
        PhotoDetailView(image: cgImage)
    }
}
