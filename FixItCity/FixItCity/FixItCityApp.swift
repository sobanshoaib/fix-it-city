//
//  FixItCityApp.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-05-23.
//

import SwiftUI

@main
struct FixItCityApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
