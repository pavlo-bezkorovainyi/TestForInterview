//
//  MoviesCollectionViewController.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 28.10.2025.
//

import UIKit

fileprivate let reuseIdentifier = "MovieCellId"

protocol MoviesCollectionViewControllerDelegate: AnyObject {
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
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
}


// MARK: - MoviesCollectionViewControllerProtocol

extension MoviesCollectionViewController: MoviesCollectionViewControllerProtocol {
  func update(movies: [MovieModel]) {
    self.movies = movies
    collectionView.reloadData()
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
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MovieCell else {
      return UICollectionViewCell()
    }
    
    let movie = movies[indexPath.item]
    
    cell.titleLabel.text = movie.title ?? "No Title"
    
    cell.backgroundColor = indexPath.item % 2 == 0 ? .lightGray : .red.withAlphaComponent(0.3)
    
    return cell
  }
}


// MARK: - UICollectionViewDelegate

extension MoviesCollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = movies[indexPath.item]
    delegate?.didSelectMovie(movie)
    //    let controller = UIHostingController(rootView: EmptyView())
    //
    //    navigationController?.pushViewController(controller, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == movies.count - 1 {
      delegate?.onDisplayLastCell()
    }
  }
}
