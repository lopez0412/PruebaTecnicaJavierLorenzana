//
//  CardView.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 16/6/24.
//

import SwiftUI

struct CardView: View {
    
  // MARK: - PROPERTIES
    var pokemon: PokemonDetails
    @State private var imageNumber: Int = 1
    @State private var isShowingShiny: Bool = false
  var body: some View {
    // MARK: - CARD
    
    ZStack {
      CustomBackgroundView()
      
      VStack {
        // MARK: - HEADER
        
        VStack(alignment: .leading) {
          HStack {
              Text(pokemon.name)
              .fontWeight(.black)
              .font(.system(size: 40))
              .foregroundStyle(
                LinearGradient(
                  colors: [
                    .customGrayLight,
                    .customGrayMedium],
                  startPoint: .top,
                  endPoint: .bottom)
              )
            
            Spacer()
            
          }
            ForEach(pokemon.stats, id: \.stat.name) { stat in
                HStack{
                    Text(stat.stat.name)
                    .multilineTextAlignment(.leading)
                    .italic()
                    .foregroundColor(.customGrayMedium)
                    
                    Text("\(stat.base_stat)")
                        .multilineTextAlignment(.leading)
                        .italic()
                        .foregroundColor(.customGrayMedium)
                }
            }
            
           
        } //: HEADER
        .padding(.horizontal, 30)
        
        // MARK: - MAIN CONTENT
        
          ZStack {
              CustomCircleView()
              if isShowingShiny{
                  AsyncImage(url: URL(string: (pokemon.sprites.front_shiny))){image in
                      image.resizable()
                  } placeholder: {
                      ProgressView()
                  }
                  .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3),radius: 3, x: 2, y: 2)
                  .frame(width: 150,height: 150,alignment: .center)
                  .animation(.default, value: imageNumber)
              }else{
                  AsyncImage(url: URL(string: (pokemon.sprites.front_default))){image in
                      image.resizable()
                  } placeholder: {
                      ProgressView()
                  }
                  .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3),radius: 3, x: 2, y: 2)
                  .frame(width: 150,height: 150,alignment: .center)
                  .animation(.default, value: imageNumber)
          }
        }
          Button {
            // ACTION: Generate a random number
              isShowingShiny.toggle()
          } label: {
              Text(isShowingShiny ? "Mostrar normal":"Mostrar Shiny")
              .font(.title2)
              .fontWeight(.heavy)
              .foregroundStyle(
                LinearGradient(
                  colors: [
                    .customGreenLight,
                    .customGreenMedium
                  ],
                  startPoint: .top,
                  endPoint: .bottom
                )
              )
              .shadow(color: .black.opacity(0.25), radius: 0.25, x: 1, y: 2)
          }
          .buttonStyle(GradientButton())
        
      } //: ZSTACK
    } //: CARD
    .frame(width: 320, height: 570)
  }
}



