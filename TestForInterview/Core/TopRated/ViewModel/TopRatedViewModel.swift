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
      }
      .store(in: &cancellables)
    
    dataService.$isLoading
      .sink { [weak self] isLoading in
        guard let self else { return }
        self.isLoading = isLoading
      }
      .store(in: &cancellables)
  }
  
  // MARK: - Public Methods
  
  func fetchMovies() {
    dataService.fetchMovies()
  }
}
