//
//  MovieCell.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 28.10.2025.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
  
  // MARK: - Public Properties
  
  var movieId: Int?
  var onStarTap: ((Int) -> Void)?
  
  
  // MARK: - Private Properties
  
  private let lblTitle: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.text
    label.numberOfLines = 1
    label.font = AppFont.font(type: .semibold, size: 14)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.minimumScaleFactor = 0.5
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  private let lblRating: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.text
    label.numberOfLines = 1
    label.font = AppFont.font(type: .medium, size: 10)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.minimumScaleFactor = 0.5
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  private let ivPoster: UIImageView = {
    let imgV = UIImageView()
    imgV.contentMode = .scaleAspectFill

    imgV.translatesAutoresizingMaskIntoConstraints = false
    imgV.layer.cornerRadius = 15.0
    imgV.clipsToBounds = true
    return imgV
  }()
  
  private let aiIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.hidesWhenStopped = true
    return indicator
  }()
  
  private let btnStar: UIButton = {
    let btn = UIButton()
    btn.frame.size = CGSize(width: 20, height: 20)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()
  
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(ivPoster)
    contentView.addSubview(aiIndicator)
    contentView.addSubview(lblTitle)
    contentView.addSubview(lblRating)
    contentView.addSubview(btnStar)
    
    NSLayoutConstraint.activate([
      ivPoster.topAnchor.constraint(equalTo: contentView.topAnchor),
      ivPoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      ivPoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      
      lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
      lblTitle.topAnchor.constraint(equalTo: ivPoster.bottomAnchor, constant: 4),
      lblTitle.heightAnchor.constraint(equalToConstant: 17),
      
      lblRating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      lblRating.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
      lblRating.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 4),
      lblRating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
      lblRating.heightAnchor.constraint(equalToConstant: 12),
      
      aiIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      aiIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      btnStar.topAnchor.constraint(equalTo: ivPoster.topAnchor, constant: 10),
      btnStar.trailingAnchor.constraint(equalTo: ivPoster.trailingAnchor, constant: -10),
    ])
    
    btnStar.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func starTapped() {
    if let movieId {
      onStarTap?(movieId)
    }
  }
  
  
  // MARK: - Overrides
  
  override func prepareForReuse() {
    super.prepareForReuse()
    ivPoster.image = nil
    ivPoster.sd_cancelCurrentImageLoad()

    lblTitle.text?.removeAll()
    lblRating.text?.removeAll()
    aiIndicator.stopAnimating()
    btnStar.setImage(nil, for: .normal)
  }
  
  
  // MARK: - Public methods
  
  func update(movieId: Int, imageUrl: URL?, title: String?, rating: Double?, isFavorite: Bool, onStarTapped: ((Int) -> Void)?) {
    self.movieId = movieId
    self.onStarTap = onStarTapped
    
    if let title {
      self.lblTitle.text = title
    }
    
    if let rating {
      let intRating = Int(rating)
      self.lblRating.text = "Rating: \(intRating)"
    }
    
    btnStar.setImage(isFavorite ? UIImage.starFill : UIImage.starEmpty, for: .normal)
    
    guard let url = imageUrl else {
      ivPoster.image = UIImage(systemName: "photo")
      return
    }
    
    aiIndicator.startAnimating()
    
    ivPoster.sd_setImage(
      with: url,
      placeholderImage: nil,
      options: [],
      completed: { [weak self] (image, error, cacheType, imageURL) in
        self?.aiIndicator.stopAnimating()
        
        if let error {
          print(error.localizedDescription)
          self?.ivPoster.image = UIImage(systemName: "exclamationmark.triangle")
        }
      }
    )
    
    
  }
}
