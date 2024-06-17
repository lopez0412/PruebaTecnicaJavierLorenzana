//
//  PokemonApi.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 14/6/24.
//

import Foundation

struct PokemonApi: Decodable, Hashable{
    let name: String
    let url: String
    var imageUrl: String? = ""
}

struct PokeData: Decodable{
    let count: Int
    let next: String
    let results : [PokemonApi]
}
