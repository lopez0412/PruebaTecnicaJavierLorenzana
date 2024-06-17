//
//  HomeViewModel.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 13/6/24.
//

import Foundation
import CoreData

class HomeViewModel: ObservableObject{
    var data = Data()
    @Published var listPokemon = [PokemonApi]()
    @Published var filteredlistPokemon = [PokemonApi]()
    @Published var error = ""
    @Published var isError = false
    
    //Funcion que trae los datos desde la api...
    func getListPokemon(context: NSManagedObjectContext, cantidad: Int){
        NetworkManager.shared.getListOfPokemon( completed: { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let listPokemon):
                    //print(listPokemon)
                    self.listPokemon = listPokemon
                    self.filteredlistPokemon = listPokemon
                    self.saveData(context: context)
                case .failure(let error):
                    print(error)
                    self.isError = true
                    switch error{
                    case .decodingError:
                        self.error = "Error al decodificar los datos"
                    case .invalidURL:
                        self.error = "URL del servicio Invalida"
                    case .unableToComplete:
                        self.error = "No se puede completar"
                    case .invalidResponse:
                        self.error = "Respuesta invalida"
                    case .invalidData:
                        self.error = "Datos invalidos"
                    }
                    
                }
            }
        },cantidad: cantidad)
    }
    
    //metodo para guardar los datos que vienen de la api en core data.
    func saveData(context: NSManagedObjectContext){
        
        
        listPokemon.enumerated().forEach { index,data in
            let entity = Pokemon(context: context)
            entity.id = Int32(index)
            entity.name = data.name
            entity.url = data.url
            entity.imageUrl = data.imageUrl
        }
        
        
        //guarda todos los datos pendientes a la vez
        do{
            try context.save()
            //print("datos guardados")
        }catch{
            print(error.localizedDescription)
            self.error = error.localizedDescription
            self.isError = true
        }
        
        
    }
}
