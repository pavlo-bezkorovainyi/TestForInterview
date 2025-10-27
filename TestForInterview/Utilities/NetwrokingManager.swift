//
//  NetwrokingManager.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 27.10.2025.
//

import Foundation
import Combine

class NetworkingManager {
  
  enum NetworkingError: LocalizedError {
    case badURLREsponse(url: URL)
    case unknown
    
    var errorDescription: String? {
      switch self {
      case .badURLREsponse(let url): return "[🔥] Bad response from URL: \(url)"
      case .unknown: return "[⚠️] Unknown error occured"
      }
    }
  }
  
  static func download(url: URL) -> AnyPublisher<Data, any Error> {
    
    var request = URLRequest(url: url)
    
    let authToken = Helper.apiKey
    request.setValue("application/json", forHTTPHeaderField: "accept")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .subscribe(on: DispatchQueue.global(qos: .default))
      .tryMap({ try handleURLResponse(output: $0, url: url) })
      .retry(3)
      .eraseToAnyPublisher()
  }
  
  static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
    guard let response = output.response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
      throw NetworkingError.badURLREsponse(url: url)
    }
    return output.data
  }
  
  
  static func handleCompletion(completion: Subscribers.Completion<Error>) {
    switch completion {
    case .finished:
      break
    case .failure(let error):
      print(error.localizedDescription)
    }
  }
}
