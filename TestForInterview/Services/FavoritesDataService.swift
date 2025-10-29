//
//  FavoritesDataService.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 29.10.2025.
//

import Foundation
import CoreData

class FavoritesDataService {
  
  // MARK: - Public Propeties
  
  @Published var savedMovies: [MovieEntity] = []
  
  
  // MARK: - Private Propeties
  
  private let container: NSPersistentContainer
  private let containerName: String = "MoviesContainer"
  private let entityName: String = "MovieEntity"
  
  
  //MARK: - Initialization
  
  init() {
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { (_, error) in
      if let error {
        print("Error loading Core Data! \(error)")
      }
      self.getMovies()
    }
  }
  
  // MARK: - Public Methods
  
  func add(movie: MovieModel) {
    let entity = MovieEntity(context: container.viewContext)
    entity.movieId = Int16(movie.id)
    entity.title = movie.title
    entity.overview = movie.overview
    entity.posterPath = movie.posterPath
    entity.rating = movie.popularity ?? 0.0
    entity.releaseDate = movie.releaseDate
  
    applyChanges()
  }
  
  func delete(movie: MovieModel) {
    if let entity = savedMovies.first(where: { $0.movieId == Int16(movie.id)}) {
      container.viewContext.delete(entity)
      applyChanges()
    }
  }
  
  
  // MARK: - Private Methods
  
  private func getMovies() {
    let request = NSFetchRequest<MovieEntity>(entityName: entityName)

    do {
      savedMovies = try container.viewContext.fetch(request)
    } catch let error {
      print("Error fetching Portfolio Entities. \(error)")
    }
  }
  
  private func save() {
    do {
      try container.viewContext.save()
    } catch let error {
      print("Error saving to Core DAta. \(error)")
    }
  }
  
  private func applyChanges() {
    save()
    getMovies()
  }
}
