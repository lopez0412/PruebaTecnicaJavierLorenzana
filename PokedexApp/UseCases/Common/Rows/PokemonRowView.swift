//
//  PokemonRowView.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 14/6/24.
//

import SwiftUI

struct PokemonRowView: View {
    //MARK: Properties
    var pokemon: PokemonApi?
    var fetchedData: Pokemon?
    
    //MARK: - BODY
    var body: some View {
        HStack{
            //Valido si la imagen se descargo correctamente y si la imagen no la descargo muestra una pokebola
            if (pokemon?.imageUrl == "" || fetchedData?.imageUrl == "") {
                Image("pokeball")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
            }else{
                AsyncImage(url: URL(string: ((pokemon == nil ? fetchedData?.imageUrl : pokemon?.imageUrl)!)))
                    .scaledToFit()
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3),radius: 3, x: 2, y: 2)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(pokemon == nil ? fetchedData!.name! : pokemon!.name)
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }//: HSTACK
    }
}

