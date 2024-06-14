//
//  PokedexAppApp.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 14/6/24.
//

import SwiftUI

@main
struct PokedexAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
