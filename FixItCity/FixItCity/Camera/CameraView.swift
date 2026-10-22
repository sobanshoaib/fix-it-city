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
    @State private var showPreview = false
    @State private var shutterCount = 0
    
    
    var body: some View {
        VStack(spacing: 0) {
            viewfinder
            controls
            Spacer(minLength: 0)
        }
        .background(Color.camBlack.ignoresSafeArea())
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showPreview) {
            if let photo = cameraVM.capturedPhoto {
                PhotoDetailView(photo: photo)
            } else {
                ProgressView().tint(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.camBlack)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: shutterCount)
        .onAppear {
            cameraVM.startCameraStream()
        }
    }
    
    private var viewfinder: some View {
        camerafeed
            .frame(maxWidth: .infinity)
            .frame(height: 600)
            .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 28, bottomTrailingRadius: 28, style: .continuous))
            .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    private var camerafeed: some View {
        if let image = cameraVM.currentFrame {
            Image(decorative: image, scale: 1)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
        } else {
                ZStack {
                    Color(white: 0.08)
                    VStack(spacing: 16) {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.3)
                        Text("Loading camera...")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
        }

                
        private var controls: some View {
            HStack {
                Spacer()

                Button{
                    cameraVM.capturedPhoto = nil
                    cameraVM.takePhoto()
                    shutterCount += 1
                    showPreview = true
                } label: {
                    ZStack {
                        Circle()
                            .stroke(.white, lineWidth: 4)
                            .frame(width: 82, height: 82)
                        Circle()
                            .fill(Color.fixRed)
                            .frame(width: 64, height: 64)
                    }
                }
                .buttonStyle(ShutterButtonStyle())

                Spacer()
            }
            .padding(.horizontal, 40)
            .padding(.top, 16)
            .padding(.bottom, 16)
    }
}

extension Color {
    static let camBlack = Color(red: 12/255, green: 6/255, blue: 6/255)
    static let camButton = Color(red: 30/255, green: 20/255, blue: 20/255)
}

struct FrameCorners: View {
    var length: CGFloat = 36
    var radius: CGFloat = 12
    var lineWidth: CGFloat = 3
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Path { p in
                p.move(to: CGPoint(x: 0, y: length))
                p.addLine(to: CGPoint(x: 0, y: radius))
                p.addQuadCurve(to: CGPoint(x: radius, y: 0), control: .zero)
                p.addLine(to: CGPoint(x: length, y: 0))
                
                p.move(to: CGPoint(x: w - length, y: 0))
                p.addLine(to: CGPoint(x: w - radius, y: 0))
                p.addQuadCurve(to: CGPoint(x: w, y: radius), control: CGPoint(x: w, y: 0))
                p.addLine(to: CGPoint(x: w, y: length))
                
                p.move(to: CGPoint(x: w, y: h - length))
                p.addLine(to: CGPoint(x: w, y: h - radius))
                p.addQuadCurve(to: CGPoint(x: w - radius, y: h), control: CGPoint(x: w, y: h))
                p.addLine(to: CGPoint(x: w - length, y: h))
                
                p.move(to: CGPoint(x: length, y: h))
                p.addLine(to: CGPoint(x: radius, y: h))
                p.addQuadCurve(to: CGPoint(x: 0, y: h - radius), control: CGPoint(x: 0, y: h))
                p.addLine(to: CGPoint(x: 0, y: h - length))
            }
            .stroke(.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
        }
        .allowsHitTesting(false)
    }
}

struct CircleIconButton: View {
    enum ButtonShape { case circle, rounded }
    
    let systemName: String
    var shape: ButtonShape = .circle
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: shape == .circle ? 25 : 14, style: .continuous)
                        .fill(Color.camButton)
                )
                .background(
                    RoundedRectangle(cornerRadius: shape == .circle ? 25 : 14, style: .continuous)
                        .stroke(.white.opacity(0.3), lineWidth: 1.5)
                )
        }
    }
}
    
    struct ShutterButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.9 : 1)
                .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
        }
    }

#Preview {
    NavigationStack {
       CameraView()
    }

}
