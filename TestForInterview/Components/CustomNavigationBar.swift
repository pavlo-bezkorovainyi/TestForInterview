//
//  CustomNavigationBar.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 29.10.2025.
//

import SwiftUI

struct CustomNavigationBar: View {
  
  // MARK: - Public properties
  
  let title: String
  let rating: String?
  let backButtonAction: (() -> Void)?
  let themeButtonAction: (() -> Void)?
  let searchButtonAction: (() -> Void)?
  let favoritesButtonAction: (() -> Void)?
  
  
  // MARK: - Initialization
  
  init(
    title: String,
    rating: String? = nil,
    backButtonAction: (() -> Void)? = nil,
    themeButtonAction: (() -> Void)? = nil,
    searchButtonAction: (() -> Void)? = nil,
    favoritesButtonAction: (() -> Void)? = nil) {
      self.title = title
      self.rating = rating
      self.backButtonAction = backButtonAction
      self.themeButtonAction = themeButtonAction
      self.searchButtonAction = searchButtonAction
      self.favoritesButtonAction = favoritesButtonAction
  }
  
  
  // MARK: - Body
  
  var body: some View {
    HStack(spacing: 24) {
      HStack(spacing: 16) {
        if let backButtonAction {
          Button {
            backButtonAction()
          } label: {
            Image(.iconLeft)
              .resizable()
              .frame(width: 24, height: 24)
              .foregroundColor(Color.text)
          }
        }
        
        HStack(spacing: 16) {
          Text(title)
            .font(Font.custom(AppFontType.bold.name, size: 30))
            .lineLimit(1)
            
          if let rating {
            Text("Average Rating: \(rating)")
              .font(Font.custom(AppFontType.bold.name, size: 10))
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      if let searchButtonAction {
        Button {
          //TODO:
          searchButtonAction()
        } label: {
          Image(.iconSearch)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(Color.text)
        }
      }
      
      if let themeButtonAction {
        Button {
          themeButtonAction()
        } label: {
          Image(.sun)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(Color.text)
        }
      }
    }
    .padding(.horizontal, 16)
    .frame(height: 35)
  }
}

#Preview {
  VStack(spacing: 50) {
    CustomNavigationBar(title: "Top Rated", rating: "31", themeButtonAction: {}, searchButtonAction: {}, favoritesButtonAction: {})
    
    CustomNavigationBar(title: "Favorites", backButtonAction: {})

    CustomNavigationBar(title: "Search", backButtonAction: {})
    
  }
}
