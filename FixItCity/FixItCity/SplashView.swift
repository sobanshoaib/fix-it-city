//
//  SplashScreen.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-05-23.
//

import SwiftUI

extension Color {
    static let fixRed = Color(red: 228/255, green: 18/255, blue: 28/255)   // #E4121C
}

struct SplashView: View {
    
    @State private var appeared = false
    @State private var progress: CGFloat = 0
    @State private var isReadyToNavigate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fixRed.ignoresSafeArea()
                
                ForEach([(340.0, 0.08), (520.0, 0.06), (720.0, 0.04)], id: \.0) { size, opacity in
                    Circle()
                        .stroke(.white.opacity(opacity), lineWidth: 1.5)
                        .frame(width: size, height: size)
                }
                
                
                VStack(spacing: 10) {
                    Text("FixItCity")
                        .font(.system(size: 40, weight: .black).width(.expanded))
                        .tracking(-0.8)
                }
                .foregroundStyle(.white)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 14)
                .animation(.easeOut(duration: 0.6).delay(0.12), value: appeared)
                
                
                
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.25))
                        Capsule().fill(.white)
                            .frame(width: 120 * progress)
                    }
                    .frame(width: 120, height: 4)
                    .padding(.bottom, 72)
                }
            }
            .onAppear {
                appeared = true
                withAnimation(.easeInOut(duration: 2.0), completionCriteria: .logicallyComplete) {
                    progress = 1
                } completion: {
                    isReadyToNavigate = true
                }
            }
            .navigationDestination(isPresented: $isReadyToNavigate) {
                CameraView()
            }
        }
    }
}

#Preview {
    SplashView()
}
