//
//  MovieViewModel.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 27.10.2025.
//

import Foundation
import Combine

class TopRatedViewModel: ObservableObject {
  
  //MARK: - Public properties
  
  @Published var movies: [MovieModel] = []
  @Published var isLoading = false
  @Published var rating: String?
  
  weak var moviesCollectionVC: MoviesCollectionViewControllerProtocol?
  
  
  // MARK: - Private Properties
  
  private let dataService = TopRatedDataService()
  private var cancellables = Set<AnyCancellable>()
  
  
  //MARK: - Initialization
  
  init() {
    addSubscribers()
    fetchMovies()
  }
  
  
  // MARK: - Private Methods
  
  private func addSubscribers() {
    dataService.$topRatedMovies
      .sink { [weak self] movies in
        guard let self else { return }
        self.movies = movies
        self.moviesCollectionVC?.update(movies: movies)
        self.rating = self.getRating()
      }
      .store(in: &cancellables)
    
    dataService.$isLoading
      .sink { [weak self] isLoading in
        guard let self else { return }
        self.isLoading = isLoading
      }
      .store(in: &cancellables)
  }
  
  private func getRating() -> String {
    let votes = movies.compactMap { $0.popularity }
    let averageVote = votes.isEmpty ? 0 : votes.reduce(0, +) / Double(votes.count)
    return String(Int(averageVote))
  }
  
  // MARK: - Public Methods
  
  func fetchMovies() {
    dataService.fetchMovies()
  }
  
  func reloadMovies() {
    dataService.reloadMovies()
  }
}
