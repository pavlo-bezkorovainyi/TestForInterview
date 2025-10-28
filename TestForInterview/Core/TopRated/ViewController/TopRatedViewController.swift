//
//  ViewController.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import UIKit
import Combine

class TopRatedViewController: UIViewController {
  
  // MARK: - Private Properties

  private var viewModel = TopRatedViewModel()
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  
  // MARK: - Overrides
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let moviesCollection = segue.destination as? MoviesCollectionViewController {
      viewModel.moviesCollectionVC = moviesCollection
      moviesCollection.delegate = self
      viewModel.fetchMovies()
    }
  }
  
  // MARK: - UI Setup
  
  private func setupUI() {

  }
}


  // MARK: - MoviesCollectionViewControllerDelegate

extension TopRatedViewController: MoviesCollectionViewControllerDelegate {
  func didSelectMovie(_ movie: MovieModel) {
    // navigation
  }
  
  func onDisplayLastCell() {
    viewModel.fetchMovies()
  }
}
