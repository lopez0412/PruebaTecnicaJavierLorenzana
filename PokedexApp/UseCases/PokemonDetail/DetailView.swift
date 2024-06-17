//
//  DetailView.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 15/6/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var detailViewModel = DetailViewModel()
    var pokemon: PokemonApi?
    var fetchedData: Pokemon?
    var body: some View {
        VStack{
            if detailViewModel.detalle == nil{
                ProgressView()
                    .onAppear{
                        detailViewModel.getDetails(url: pokemon == nil ? fetchedData!.url! : pokemon!.url)
                    }//:Onappear
            } else{
                CardView(pokemon: detailViewModel.detalle!)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(pokemon: PokemonApi(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
    }
}
