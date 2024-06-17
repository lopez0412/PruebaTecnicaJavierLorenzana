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
    @StateObject var pokeViewModel = HomeViewModel()
    @State var cantidadPokemon = 5
    
    var body: some Scene {
        WindowGroup {
            ContentView(pokeViewModel: pokeViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .backgroundTask(.appRefresh("Actualiza")) {
            await refreshData()
        }
    }
    
    func refreshData() async{
        let content = UNMutableNotificationContent()
        content.title = "Actualizacion de lista Pokemon"
        content.subtitle="La Lista de pokemon se ha actualizado. Puedes verla!"
        
        if await getPokes(){
            try? await UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "probando", content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: true)))
        }
    }
    
    func getPokes() async -> Bool{
        cantidadPokemon += 5
        pokeViewModel.listPokemon.removeAll()
        
        pokeViewModel.getListPokemon(context: persistenceController.container.viewContext, cantidad: cantidadPokemon)
        
        return true
    }
    
   
}
