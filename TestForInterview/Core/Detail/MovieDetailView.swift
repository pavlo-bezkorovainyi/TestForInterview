//
//  MovieDetailView.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 30.10.2025.
//

import SwiftUI
import SDWebImage
import Combine

class MovieDetailViewModel: ObservableObject {
  
  // MARK: - Public Properties
  
  @Published var movie: MovieModel?
  @Published var isFavorite: Bool = false
  var movieId: Int?
  
  
  // MARK: - Private Properties
  
  private let favoritesDataService = FavoritesDataService.shared
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initialization
  
  init(movie: MovieModel? = nil, movieId: Int? = nil) {
    self.movie = movie
    self.movieId = movieId
    
    addSubscribers()
  }
  
  
  // MARK: - Private Methods
  
  private func addSubscribers() {
    favoritesDataService.$savedMovies
      .sink { [weak self] savedMovies in
        guard let self, let movie else { return }
        let favoriteMovies = savedMovies.compactMap({ MovieModel(from: $0) })
        let isFavoriteCalculated = favoriteMovies.contains(where: { $0.id == movie.id})
        isFavorite = isFavoriteCalculated
      }
      .store(in: &cancellables)
  }
  
  
  // MARK: - Public Methods
  
  func favoriteAction() {
    guard let movie else { return }
    if isFavorite {
      favoritesDataService.delete(movie: movie)
    } else {
      favoritesDataService.add(movie: movie)
    }
  }
  
}

struct MovieDetailView: View {
  
  // MARK: - Public Properties
  
  @ObservedObject var viewModel: MovieDetailViewModel
  let onBackButtonPressed: () -> Void
  
  
  // MARK: - Initialization
  
  init(movie: MovieModel? = nil, movieId: Int? = nil, onBackButtonPressed: @escaping () -> Void) {
    self.viewModel = MovieDetailViewModel(movie: movie, movieId: movieId)
    self.onBackButtonPressed = onBackButtonPressed
  }
  
  
  // MARK: - Body
  
  var body: some View {
    VStack(spacing: 24) {
      CustomNavigationBar(title: viewModel.movie?.title ?? "Movie", backButtonAction: {
        onBackButtonPressed()
      })
      
      VStack(spacing: 16) {
        VStack(spacing: 8) {
          poster
          rating
          
        }
        overview
        favoritesButton
      }
      
      Spacer()
    }
  }
  
  // MARK: - Views
  
  @ViewBuilder
  private var poster: some View {
    if let movie = viewModel.movie {
      SDWebImageView(
        url: movie.imgURL,
        placeholder: UIImage(systemName: "photo"),
        contentMode: .scaleAspectFill,
        options: [.retryFailed, .highPriority]
      )
      .frame(
        width: UIScreen.main.bounds.width * (250/375),
        height: UIScreen.main.bounds.height * (357/823)
      )
      .cornerRadius(15)
    }
  }
  
  @ViewBuilder
  private var rating: some View {
    if let movie = viewModel.movie, let popularity = movie.popularity {
      Text("Rating: \(Int(popularity))")
        .foregroundColor(.text)
        .setFont(type: .medium, size: 10)
    }
  }
  
  @ViewBuilder
  private var overview: some View {
    if let movie = viewModel.movie, let overview = movie.overview {
      Text(overview)
        .foregroundColor(.text)
        .setFont(type: .regual, size: 15)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  private var favoritesButton: some View {
    Button {
      viewModel.favoriteAction()
    } label: {
      Text("\(viewModel.isFavorite ? "Remove from favorites" : "Add to favorites")")
        .setFont(type: .semibold, size: 16)
        .foregroundColor(viewModel.isFavorite ? Color.btnTxt2 : Color.btnTxt1)
        .frame(height: 47)
        .frame(maxWidth: .infinity)
        .background(
          RoundedRectangle(cornerRadius: 32)
            .stroke(lineWidth: viewModel.isFavorite ? 1 : 0)
            .fill(Color.btnTxt2)
        )
        .background(viewModel.isFavorite ? Color.background : Color.btnBg1)
        .cornerRadius(32)
        .padding(.horizontal, 16)
    }
  }
}

#Preview {
  MovieDetailView(movie: .mock, movieId: nil, onBackButtonPressed: {
    
  })
}
