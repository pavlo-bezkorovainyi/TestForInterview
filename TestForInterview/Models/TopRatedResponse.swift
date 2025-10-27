//
//  Welcome.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 27.10.2025.
//

import Foundation

struct TopRatedResponse: Codable {
  let page: Int
  let results: [MovieModel]
  let totalPages, totalResults: Int
  
  enum CodingKeys: String, CodingKey {
    case page, results
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
}

