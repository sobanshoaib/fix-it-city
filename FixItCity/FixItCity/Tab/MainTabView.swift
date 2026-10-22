//
//  MainTabView.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-10-21.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Camera", systemImage: "camera.fill") {
                NavigationStack {
                    CameraView()
                }
            }
            
            Tab("Reports", systemImage: "list.bullet.clipboard") {
                NavigationStack {
                    ReportListView()
                }
            }
        }
    }
}

#Preview {
     MainTabView()
         .environment(\.managedObjectContext,
 PersistenceController.preview.container.viewContext)
 }
