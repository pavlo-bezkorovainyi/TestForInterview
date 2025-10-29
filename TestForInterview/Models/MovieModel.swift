//
//  MovieModel.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 27.10.2025.
//

import Foundation

struct MovieModel: Codable {
  let id: Int
  let overview: String?
  let popularity: Double?
  let posterPath: String?
  let releaseDate: String?
  let title: String?
  
  init(from entity: MovieEntity) {
    self.id = Int(entity.movieId)
    self.title = entity.title
    self.overview = entity.overview
    self.posterPath = entity.posterPath
    self.releaseDate = entity.releaseDate
    self.popularity = entity.rating
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case overview
    case popularity
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case title
  }
  
  var imgURL: URL? {
    URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath ?? "")")
  }
}
