////
////  Project.swift
////  HRProject
////
////  Created by mahmoud khudairi on 5/22/17.
////  Copyright © 2017 mahmoud khudairi. All rights reserved.
////
//
import UIKit
class Project {
  var id: Int?
  var name: String?
  var dateCreated: String?
  var dateEnded: String?
  var profileImagesUrl: [String]?

  
  init(dictionary: [String: Any]) {

    self.id = dictionary["id"] as? Int ?? 0
    self.name = dictionary["name"] as? String

//    guard let images = dictionary["avatar"] as? [String:Any] else{return }
//    
//    for image in (images["medium"] as? [String:Any])! {
//      self.profileImageUrl = image.value as? String ?? ""
//    }
     let startStringDate = dictionary["started"] as? String ??  "2017-01-01"
    let startDate = Formatter.storeDateFormatter.date(from: startStringDate)
     self.dateCreated = Formatter.displayDateFormatter.string(from: startDate!)
    let stringDate = dictionary["completed"] as? String ??  "2017-05-05"
    let date = Formatter.storeDateFormatter.date(from: stringDate)
    self.dateEnded = Formatter.displayDateFormatter.string(from: date!)
    
    
    
  }
}
