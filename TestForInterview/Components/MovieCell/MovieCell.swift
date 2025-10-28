//
//  MovieCell.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 28.10.2025.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
  
  // MARK: - Private Properties
  
  private let lblTitle: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.minimumScaleFactor = 0.5
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  private let lblRating: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.minimumScaleFactor = 0.5
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  private let ivPoster: UIImageView = {
    let imgV = UIImageView()
    imgV.contentMode = .scaleAspectFill
    imgV.clipsToBounds = true
    imgV.translatesAutoresizingMaskIntoConstraints = false
    imgV.layer.cornerRadius = 15.0
    return imgV
  }()
  
  private let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.hidesWhenStopped = true
    //    indicator.color = .white
    return indicator
  }()
  
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(ivPoster)
    contentView.addSubview(activityIndicator)
    contentView.addSubview(lblTitle)
    contentView.addSubview(lblRating)
    
    NSLayoutConstraint.activate([
      ivPoster.topAnchor.constraint(equalTo: contentView.topAnchor),
      ivPoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      ivPoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      
      lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
      lblTitle.topAnchor.constraint(equalTo: ivPoster.bottomAnchor, constant: 4),
      
      lblRating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      lblRating.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
      lblRating.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 4),
      lblRating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
      
      activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Overrides
  
  override func prepareForReuse() {
    super.prepareForReuse()
    ivPoster.image = nil
    ivPoster.sd_cancelCurrentImageLoad()
    
    lblTitle.text = nil
    activityIndicator.stopAnimating()
  }
  
  
  // MARK: - Public methods
  
  func update(imageUrl: URL?, title: String?, rating: Double?) {
    if let title {
      self.lblTitle.text = title
    }
    
    if let rating {
      let intRating = Int(rating)
      self.lblRating.text = "Rating: \(intRating)"
    }
    
    guard let url = imageUrl else {
      ivPoster.image = UIImage(systemName: "photo") // Заглушка
      return
    }
    
    activityIndicator.startAnimating()
    
    ivPoster.sd_setImage(
      with: url,
      placeholderImage: nil,
      options: [],
      completed: { [weak self] (image, error, cacheType, imageURL) in
        self?.activityIndicator.stopAnimating()
        
        if let error {
          print(error.localizedDescription)
          self?.ivPoster.image = UIImage(systemName: "exclamationmark.triangle")
        }
      }
    )
  }
}
