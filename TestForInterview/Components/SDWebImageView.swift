//
//  SDWebImageView.swift
//  TestForInterview
//
//  Created by Pavlo Bezkorovainyi on 30.10.2025.
//

import SwiftUI
import SDWebImage

struct SDWebImageView: UIViewRepresentable {
  let url: URL?
  var placeholder: UIImage? = nil
  var contentMode: UIView.ContentMode = .scaleAspectFill
  var options: SDWebImageOptions = []
  
  func makeUIView(context: Context) -> UIView {
    let container = UIView()
    container.clipsToBounds = true
    
    let imageView = UIImageView()
    imageView.contentMode = contentMode
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .clear
    container.addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      imageView.topAnchor.constraint(equalTo: container.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])
    
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.hidesWhenStopped = true
    indicator.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(indicator)
    NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      indicator.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])
    
    context.coordinator.imageView = imageView
    context.coordinator.indicator = indicator
    
    return container
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
    guard let imageView = context.coordinator.imageView,
          let indicator = context.coordinator.indicator else {
      return
    }
    
    imageView.contentMode = contentMode
    
    imageView.sd_cancelCurrentImageLoad()
    
    indicator.startAnimating()
    
    imageView.sd_setImage(with: url, placeholderImage: placeholder, options: options) { [weak imageView, weak indicator] (image, error, cacheType, imageURL) in
      DispatchQueue.main.async {
        indicator?.stopAnimating()
        
        if let error = error {
          print("SDWebImage error:", error.localizedDescription)
          if image == nil {
            imageView?.image = UIImage(systemName: "exclamationmark.triangle")
            imageView?.tintColor = .lightGray
            imageView?.contentMode = .center
          }
        } else {
          imageView?.contentMode = contentMode
        }
      }
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator()
  }
  
  class Coordinator {
    weak var imageView: UIImageView?
    weak var indicator: UIActivityIndicatorView?
  }
}
