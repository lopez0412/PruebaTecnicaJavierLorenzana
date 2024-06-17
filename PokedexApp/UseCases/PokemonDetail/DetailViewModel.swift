//
//  DetailViewModel.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 16/6/24.
//

import Foundation
import CoreData

class DetailViewModel: ObservableObject{
    var data = Data()
    @Published var detalle : PokemonDetails?
    @Published var error = ""
    @Published var isError = false
    
    //Funcion que trae los datos desde la api...
    func getDetails(url: String){
        NetworkManager.shared.getDetails(completed: { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let pokedetail):
                    //print(listPokemon)
                    self.detalle = pokedetail
                case .failure(let error):
                    print(error)
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
                    self.isError = true
                }
            }
        },url: url)
    }
    
    
}
