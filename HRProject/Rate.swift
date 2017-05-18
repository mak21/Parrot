//
//  Rate.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/18/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
class Rate {
  var positive_attitude: Int!
  var creativity:Int!
  var responsibility: Int!
  var teamwork: Int!
  var critical_thinking: Int!
  var comment : String!
  
  
  init(dictionary: [String: Any]) {
    
     positive_attitude = dictionary["positive_attitude"] as? Int
     creativity = dictionary["creativity"] as? Int
     responsibility = dictionary["responsibility"] as? Int
     teamwork = dictionary["teamwork"] as? Int
     critical_thinking = dictionary["critical_thinking"] as? Int
     comment = dictionary["comment"] as? String
  }
}
