//
//  PokemonDetails.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 14/6/24.
//

import Foundation

struct PokemonDetails: Decodable{
    let name: String
    let sprites: spriteRequired
    let stats: [Stats]
}

struct spriteRequired: Decodable{
    let front_default: String
    let front_shiny: String
}

struct Stats: Decodable{
    let base_stat: Int
    let stat: Stadistic
}
struct Stadistic: Decodable{
    let name: String
}
