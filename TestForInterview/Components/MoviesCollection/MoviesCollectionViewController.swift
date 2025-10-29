//
//  MoviesCollectionViewController.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 28.10.2025.
//

import UIKit

fileprivate let reuseIdentifier = "MovieCellId"

protocol MoviesCollectionViewControllerDelegate: AnyObject {
  func onRefresh()
  func didSelectMovie(_ movie: MovieModel)
  func onDisplayLastCell()
}

protocol MoviesCollectionViewControllerProtocol: AnyObject {
  func update(movies: [MovieModel])
}

class MoviesCollectionViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  
  // MARK: - Public Propeties
  
  var movies: [MovieModel] = []
  weak var delegate: MoviesCollectionViewControllerDelegate?
  
  
  // MARK: - Private Properties
  
  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    return refreshControl
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(MovieCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.estimatedItemSize = .zero
    }
    collectionView.refreshControl = refreshControl
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  
  // MARK: - Private Methods
  
  @objc private func handleRefresh() {
    delegate?.onRefresh()
  }
}

// MARK: - MoviesCollectionViewControllerProtocol

extension MoviesCollectionViewController: MoviesCollectionViewControllerProtocol {
  func update(movies: [MovieModel]) {
    self.movies = movies
    collectionView.reloadData()
    refreshControl.endRefreshing()
  }
}


// MARK: - UICollectionViewDataSource

extension MoviesCollectionViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MovieCell,
          movies.indices.contains(indexPath.item)
    else {
      return UICollectionViewCell()
    }
    
    let movie = movies[indexPath.item]
    
    cell.update(imageUrl: movie.imgURL, title: movie.title ?? "No title", rating: movie.popularity)
    
    return cell
  }
}


// MARK: - UICollectionViewDelegate

extension MoviesCollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = movies[indexPath.item]
    delegate?.didSelectMovie(movie)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == movies.count - 1 {
      delegate?.onDisplayLastCell()
    }
  }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let leftInset: CGFloat = 16
    let rightInset: CGFloat = 16
    let horizontalSpacing: CGFloat = 16
    
    let numberOfColumns: CGFloat = 2
    
    let totalHorizontalPadding = leftInset + rightInset + horizontalSpacing

    let availableWidth = collectionView.bounds.width - totalHorizontalPadding
    
    let itemWidth = availableWidth / numberOfColumns
    
    let itemHeight = itemWidth * 1.7
    
    guard itemWidth > 0, itemHeight > 0 else {
      return .zero
    }
    
    return CGSize(width: itemWidth, height: itemHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }
  
}
