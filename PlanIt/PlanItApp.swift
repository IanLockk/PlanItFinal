//
//  PlanItApp.swift
//  PlanIt
//
//  Created by Ian Lockwood on 4/26/22.
//

import SwiftUI

@main
struct PlanItApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
