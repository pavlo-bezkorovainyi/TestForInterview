//
//  ViewController.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import UIKit
import SwiftUI
import Combine

fileprivate let kMovieCellId = "MovieCellId"

class MovieCell: UICollectionViewCell {
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    backgroundColor = nil
  }
}

class ViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
  // MARK: - Properties

  private var viewModel = TopRatedViewModel()
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    bindViewModel()
    
    viewModel.fetchMovies()
  }
  
  // MARK: - UI Setup
  
  private func setupUI() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(MovieCell.self, forCellWithReuseIdentifier: kMovieCellId)
  }
  
  // MARK: - ViewModel Binding
  
  private func bindViewModel() {
    viewModel.$movies
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.collectionView.reloadData()
      }
      .store(in: &cancellables)
  }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMovieCellId, for: indexPath) as? MovieCell else {
      return UICollectionViewCell()
    }
    
    let movie = viewModel.movies[indexPath.item]
    
    cell.titleLabel.text = movie.title ?? "No Title"
    
    cell.backgroundColor = indexPath.item % 2 == 0 ? .lightGray : .red.withAlphaComponent(0.3)
    
    return cell
  }
  
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let controller = UIHostingController(rootView: EmptyView())
    
    navigationController?.pushViewController(controller, animated: true)
  }
  
  // MARK: - Pagination
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.item == viewModel.movies.count - 1 {
      if !viewModel.isLoading {
        print("Fetching next pages...")
        viewModel.fetchMovies()
      }
    }
  }
}
