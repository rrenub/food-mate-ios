//
//  SearchFooter.swift
//  food-mate-uikit
//
//  Created by Ruben Delgado on 29/12/2020.
//

import UIKit

class SearchFooter: UIView {
  let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configureView()
  }
  
  override func draw(_ rect: CGRect) {
    label.frame = bounds
  }
  
  func setNotFiltering() {
    label.text = ""
    hideFooter()
  }
  
  func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
    if (filteredItemCount == totalItemCount) {
      setNotFiltering()
    } else if (filteredItemCount == 0) {
      label.text = "No items match your query"
      showFooter()
    } else {
      label.text = "Filtering \(filteredItemCount) of \(totalItemCount)"
      showFooter()
    }
  }
  
  func hideFooter() {
    UIView.animate(withDuration: 0.7) {
      self.alpha = 0.0
    }
  }
  
  func showFooter() {
    UIView.animate(withDuration: 0.7) {
      self.alpha = 1.0
    }
  }
  
  func configureView() {
    backgroundColor = UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    alpha = 0.0
    
    label.textAlignment = .center
    label.textColor = UIColor.white
    addSubview(label)
  }
}

