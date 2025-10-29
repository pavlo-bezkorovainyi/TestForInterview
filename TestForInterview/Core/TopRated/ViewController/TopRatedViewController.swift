//
//  ViewController.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import UIKit
import SwiftUI
import Combine

class TopRatedViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var navBarContainer: UIView!
  
  // MARK: - Private Properties

  private var viewModel = TopRatedViewModel()
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindRating()
  }
  
  
  // MARK: - Overrides
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let moviesCollection = segue.destination as? MoviesCollectionViewController {
      viewModel.moviesCollectionVC = moviesCollection
      moviesCollection.delegate = self
      viewModel.fetchMovies()
    }
  }
  
  // MARK: - Private methods
  
  private func setupUI() {
    let navBar = CustomNavigationBar(
      title: "Top Rated",
      rating: viewModel.rating,
      themeButtonAction: {
        //TODO: THEME
      }, searchButtonAction: {
        //TODO: SEARCH
      }, favoritesButtonAction: {
        //TODO: FAVORITES
      }
    )
    
    let hosting = UIHostingController(rootView: navBar)
    
    addChild(hosting)
    navBarContainer.addSubview(hosting.view)
    hosting.didMove(toParent: self)

    hosting.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
        hosting.view.topAnchor.constraint(equalTo: navBarContainer.topAnchor),
        hosting.view.leadingAnchor.constraint(equalTo: navBarContainer.leadingAnchor),
        hosting.view.trailingAnchor.constraint(equalTo: navBarContainer.trailingAnchor),
        hosting.view.bottomAnchor.constraint(equalTo: navBarContainer.bottomAnchor)
    ])
  }
  
  private func bindRating() {
    viewModel.$rating
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.setupUI()
      }
      .store(in: &cancellables)
  }
}

  // MARK: - MoviesCollectionViewControllerDelegate

extension TopRatedViewController: MoviesCollectionViewControllerDelegate {
  func checkIfMovieIsFavorite(_ movie: MovieModel) -> Bool {
    viewModel.checkIfMovieIsFavorite(movie)
  }
  
  func onStarTapped(movie: MovieModel) {
    viewModel.addOrRemoveFromFavorites(movie: movie)
  }
  
  func onRefresh() {
    viewModel.reloadMovies()
  }
  
  func didSelectMovie(_ movie: MovieModel) {
    //TODO: GO TO DETAILS
  }
  
  func onDisplayLastCell() {
    viewModel.fetchMovies()
  }
}
