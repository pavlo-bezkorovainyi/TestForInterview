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
  
  init(
    id: Int,
    overview: String?,
    popularity: Double?,
    posterPath: String?,
    releaseDate: String?,
    title: String?
  ) {
    self.id = id
    self.overview = overview
    self.popularity = popularity
    self.posterPath = posterPath
    self.releaseDate = releaseDate
    self.title = title
  }
  
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
  
  static var mock: MovieModel {
    .init(
      id: 0,
      overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
      popularity: 18,
      posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
      releaseDate: "1999-10-15",
      title: "Fight Club"
    )
  }
}
