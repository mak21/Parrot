//
//  Formatter.swift
//  ManageExpense
//
//  Created by mahmoud khudairi on 5/3/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import Foundation
class Formatter {
  static let displayDateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateStyle = DateFormatter.Style.medium
    formatter.timeStyle = DateFormatter.Style.none
    return formatter
  }()
  static let storeDateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    let locale = Locale(identifier: "en_US_POSIX")
    formatter.locale = locale
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
 
  
 
}
