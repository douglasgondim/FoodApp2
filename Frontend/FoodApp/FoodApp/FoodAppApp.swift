//
//  FoodAppApp.swift
//  FoodApp
//
//  Created by Douglas Gondim on 09/11/23.
//

import SwiftUI

@main
struct FoodAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
