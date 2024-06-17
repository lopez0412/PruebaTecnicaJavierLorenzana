//
//  NetworkManager.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 13/6/24.
//

import Foundation

enum APError: Error{
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    case decodingError
}

class NetworkManager{
    static let shared = NetworkManager()
    
    init() {
        
    }
    
    func getListOfPokemon(completed: @escaping (Result<[PokemonApi], APError>) -> Void, cantidad: Int) {
            // Validacion de la url
           guard let url = URL(string: Constants().kPokemonApi+"?limit=\(cantidad)") else {
               completed(.failure(.invalidURL))
               return
           }
           
           let task = URLSession.shared.dataTask(with: url) { data, _, error in
               //validacion de la data.
               guard let data = data else {
                   completed(.failure(.unableToComplete))
                   return
               }
               
               do {
                   // decodificador de la data.
                   let decoder = JSONDecoder()
                   let decodedResponse = try decoder.decode(PokeData.self, from: data)
                   
                   var pokemonList = decodedResponse.results
                   
                   // Obtenemos la url de cada pokemon para traer las imagenes
                   for index in 0..<pokemonList.count {
                       let pokemon = pokemonList[index]
                       guard let pokemonURL = URL(string: pokemon.url) else {
                           completed(.failure(.invalidURL))
                           return
                       }
                       
                       // Hacer la solicitud para obtener los detalles del Pokémon
                       URLSession.shared.dataTask(with: pokemonURL) { data, _, error in
                           guard let data = data else {
                               completed(.failure(.unableToComplete))
                               return
                           }
                           
                           do {
                               let pokemonDetails = try decoder.decode(PokemonDetails.self, from: data)
                               //print(index)
                               //print(pokemonDetails)
                               
                               if pokemonList[index].imageUrl == "" {
                                   // Actualizar la URL de la imagen en la lista de Pokémon
                                   pokemonList[index].imageUrl = pokemonDetails.sprites.front_default
                               }
                               // Verificar si hemos actualizado todas las URL de imagen
                               if index == pokemonList.count - 1 {
                                   completed(.success(pokemonList))
                               }
                           } catch {
                               completed(.failure(.decodingError))
                           }
                       }.resume()
                   }
                   
               } catch {
                   completed(.failure(.decodingError))
               }
           }
           
           task.resume()
       }
    
    func getDetails(completed: @escaping (Result<PokemonDetails, APError>) -> Void, url: String){
        // Validacion de la url
       guard let url = URL(string: url) else {
           completed(.failure(.invalidURL))
           return
       }
       
       let task = URLSession.shared.dataTask(with: url) { data, _, error in
           //validacion de la data.
           guard let data = data else {
               completed(.failure(.unableToComplete))
               return
           }
           
           do {
               // decodificador de la data.
               let decoder = JSONDecoder()
               let decodedResponse = try decoder.decode(PokemonDetails.self, from: data)
               
               let pokemonDetails = decodedResponse
               
               completed(.success(pokemonDetails))
               
           } catch {
               completed(.failure(.decodingError))
           }
       }
       
       task.resume()
    }
    
   }
