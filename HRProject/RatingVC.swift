//
//  VoteVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Cosmos
class RatingVC: UIViewController {
  var ratingDict : [String:Int] = [:]
  @IBOutlet weak var criticalRate: CosmosView!{
    didSet{
      criticalRate.didFinishTouchingCosmos = { rating in
        self.ratingDict ["criticalRate"] = Int(rating)
      }
    }
  }
  @IBOutlet weak var teamworkRate: CosmosView!{
    didSet{
      teamworkRate.didFinishTouchingCosmos = { rating in
        self.ratingDict ["teamworkRate"] = Int(rating)
      }
    }
  }
  @IBOutlet weak var responsibilityRate: CosmosView!{
    didSet{
      responsibilityRate.didFinishTouchingCosmos = { rating in
        self.ratingDict ["responsibilityRate"] = Int(rating)
      }
    }
  }
  @IBOutlet weak var creativityRate: CosmosView!{
    didSet{
      creativityRate.didFinishTouchingCosmos = { rating in
        self.ratingDict ["creativityRate"] = Int(rating)
      }
    }
  }
  @IBOutlet weak var positiveAttitudeRate: CosmosView!{
    didSet{
      positiveAttitudeRate.didFinishTouchingCosmos = { rating in
        self.ratingDict ["positiveAttitudeRate"] = Int(rating)
      }
    }
  }
 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  
  @IBAction func submitButtonPressed(_ sender: Any) {
    
    print(ratingDict)
    navigationController?.popViewController(animated: true)
  }
  


}
