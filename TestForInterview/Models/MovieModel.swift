//
//  MovieModel.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 27.10.2025.
//

import Foundation

struct MovieModel: Codable {
  let id: Int
  let originalLanguage, originalTitle, overview: String?
  let popularity: Double?
  let posterPath, releaseDate, title: String?
  let voteAverage: Double?
  let voteCount: Int?
  
  enum CodingKeys: String, CodingKey {
    case id
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview, popularity
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case title
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
  
  var imgURL: URL? {
    URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath ?? "")")
  }
}
