//
//  Member.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/18/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
class Member {
  var id: Int?
  var name: String?
  var email: String?
  var privilege: String?
  var profileImageUrl: String?
  var department : String?
  var title : String?
  
  init(dictionary: [String: Any]) {
    
   
      
    self.id = dictionary["id"] as? Int
    self.name = dictionary["full_name"] as? String
    self.email = dictionary["email"] as? String
      guard let images = dictionary["avatar"] as? [String:Any] else{return }
      
      for image in (images["medium"] as? [String:Any])! {
         self.profileImageUrl = image.value as? String ?? "" 
      }
    
    self.department = dictionary["department"] as? String
    self.title = dictionary["title"] as? String
    
  }
}
