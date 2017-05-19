//
//  Rate.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/18/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
class Rate {
  var positive_attitude: Int?
  var creativity:Int?
  var responsibility: Int?
  var teamwork: Int?
  var critical_thinking: Int?
  var comment : String?
   
  
  init(dictionary: [String: Any]) {
   
    //for dict in dictionary{
      
           positive_attitude = dictionary["positive_attitude"] as? Int ?? 0
           creativity = dictionary["creativity"] as? Int ?? 0
           responsibility = dictionary["responsibility"] as? Int ?? 0
           teamwork = dictionary["teamwork"] as? Int ?? 0
           critical_thinking = dictionary["critical_thinking"] as? Int ?? 0
           comment = dictionary["comment"] as? String ?? ""

//      positive_attitudeSum += Double(positive_attitude! )
//      creativitySum += Double(creativity!)
//      responsibilitySum += Double(responsibility!)
//      teamworkSum += Double(teamwork!)
//      critical_thinkingSum = Double(critical_thinking!)
      
  //  }
    


  
    
}
}
