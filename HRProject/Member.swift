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
  
//  init(dictionary: [[String: Any]]) {
//    
//    for d in dictionary{
//      
//      guard let name = d["full_name"] as? String else { return}
//    self.id = d["id"] as? Int ?? 0
//    self.name = name
//      
//    self.email = d["email"] as? String
//    self.profileImageUrl = d["avatar_url"] as? String
////       guard let images = d["avatar_url"] as? [String:Any] else{return }
////      for image in (images["medium"] as? [String:Any])! {
////        
////         self.profileImageUrl = image.value as? String ?? "" 
////      }
//    
//    self.department = d["department"] as? String
//    self.title = d["title"] as? String
//    
//  }
//  }
//}
  init(d: [String: Any]) {
    
    
      
      guard let name = d["full_name"] as? String else { return}
      self.id = d["id"] as? Int ?? 0
      self.name = name
      
      self.email = d["email"] as? String
      self.profileImageUrl = d["avatar_url"] as? String
      //       guard let images = d["avatar_url"] as? [String:Any] else{return }
      //      for image in (images["medium"] as? [String:Any])! {
      //
      //         self.profileImageUrl = image.value as? String ?? ""
      //      }
      
      self.department = d["department"] as? String
      self.title = d["title"] as? String
      
    
  }
}
