//
//  SearchViewController.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 30.10.2025.
//

import UIKit
import Combine
import SwiftUI

class SearchViewController: UIViewController, StoryboardInitializable {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var navBarContainer: UIView!
  @IBOutlet weak var searchContainer: UIView!
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var resultsLabel: UILabel!
  
  // MARK: - Private Properties

//  private var viewModel = TopRatedViewModel()
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  
  // MARK: - Overrides
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let moviesCollection = segue.destination as? MoviesCollectionViewController {
//      viewModel.moviesCollectionVC = moviesCollection
//      moviesCollection.delegate = self
//      viewModel.fetchMovies()
    }
  }
  
  // MARK: - Private methods
  
  private func setupUI() {
    setupNavigationBar()
    setupSearchField()
    
    searchContainer.layer.cornerRadius = 10
  }
  
  private func setupNavigationBar() {
    let navBar = CustomNavigationBar(
      title: "Search", backButtonAction: {
        self.navigationController?.popViewController(animated: true)
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
  
  private func setupSearchField() {
    searchTextField.delegate = self
    
    searchTextField.font = AppFont.font(type: .medium, size: 18)
    searchTextField.textColor = UIColor.text
    
    searchTextField.returnKeyType = .search
    searchTextField.autocorrectionType = .no
    searchTextField.clearButtonMode = .whileEditing
    
    let placeholderAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.text.withAlphaComponent(0.2),
      .font: AppFont.font(type: .bold, size: 18)
    ]
    searchTextField.attributedPlaceholder = NSAttributedString(
      string: "Search",
      attributes: placeholderAttributes
    )
  }
}


// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     textField.resignFirstResponder()
     return true
   }
  
  func textField(_ textField: UITextField, shouldChangeCharactersInRanges ranges: [NSValue], replacementString string: String) -> Bool {
    
    return true
  }
}
