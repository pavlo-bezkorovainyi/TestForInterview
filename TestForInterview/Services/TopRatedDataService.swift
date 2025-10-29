//
//  TopRatedDataService.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 27.10.2025.
//

import Foundation
import Combine

class TopRatedDataService {
  
  //MARK: - Public properties
  
  @Published var topRatedMovies: [MovieModel] = []
  @Published var isLoading = false
  
  
  //MARK: - Private properties
  
  private var currentPage = 0
  private var cancellables = Set<AnyCancellable>()
  
  private func createMovieURL(for page: Int) -> URL? {
    guard var components = URLComponents(string: "https://api.themoviedb.org/3/movie/top_rated") else { return nil }
    
    let queryItems = [
      URLQueryItem(name: "page", value: "\(page)")
    ]
    
    components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
    
    return components.url
  }
  
  
  //MARK: - Public methods
  
  func reloadMovies() {
    currentPage = 0
    topRatedMovies.removeAll()
    fetchMovies()
  }
  
  func fetchMovies() {
    guard !isLoading else { return }
    isLoading = true
    
    let pageToFetch1 = currentPage + 1
    let pageToFetch2 = currentPage + 2
    
    guard let url1 = createMovieURL(for: pageToFetch1),
          let url2 = createMovieURL(for: pageToFetch2) else {
      print("Error create URL")
      isLoading = false
      return
    }
    
    let publisher1 = NetworkingManager.download(url: url1)
      .decode(type: TopRatedResponse.self, decoder: JSONDecoder())
    
    let publisher2 = NetworkingManager.download(url: url2)
      .decode(type: TopRatedResponse.self, decoder: JSONDecoder())
    
    Publishers.Zip(publisher1, publisher2)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          self?.isLoading = false
          
          switch completion {
          case .finished:
            print("Successfully fetched pages \(pageToFetch1) and \(pageToFetch2).")
          case .failure(let error):
            print("Error fetching pages: \(error.localizedDescription)")
          }
        },
        receiveValue: { [weak self] (response1, response2) in
          self?.topRatedMovies.append(contentsOf: response1.results)
          self?.topRatedMovies.append(contentsOf: response2.results)
          
          self?.currentPage = pageToFetch2
        }
      )
      .store(in: &cancellables)
  }
}
