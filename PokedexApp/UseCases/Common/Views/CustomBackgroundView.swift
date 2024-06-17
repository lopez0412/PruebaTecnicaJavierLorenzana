//
//  CustomBackgroundView.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 16/6/24.
//

import SwiftUI

struct CustomBackgroundView: View {
  var body: some View {
    ZStack {
      // MARK: - 3. DEPTH
      
      Color.customPictonBlue
        .cornerRadius(40)
        .offset(y: 12)
      
      // MARK: - 2. LIGHT
      
      Color.customArgentinianBlue
        .cornerRadius(40)
        .offset(y: 3)
        .opacity(0.85)
      
      // MARK: - 1. SURFACE
      
      LinearGradient(
        colors: [
          .customPictonBlue,
          .customArgentinianBlue],
        startPoint: .top,
        endPoint: .bottom
      )
      .cornerRadius(40)
    }
  }
}

struct CustomBackgroundView_Previews: PreviewProvider {
  static var previews: some View {
    CustomBackgroundView()
      .padding()
  }
}

