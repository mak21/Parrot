//
//  TeamVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Cosmos
class TeamVC: UIViewController {
  var ratingDict : [String:Any] = ["positive_attitude":0,"creativity":0,"responsibility":0,"teamwork":0,"critical_thinking":0,"Comment":""]
  var categories = ["Positive Attitude","Creativity","Responsibility","TeamworkRate","Critical Thinking", "comment"]
  var i = 0
  @IBOutlet weak var ratingButton: UIButton!
  @IBOutlet var ratingView: UIView!

  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var selectedPersonNameLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var cosomosRateView: CosmosView!{
    didSet{
//      cosomosRateView.didFinishTouchingCosmos = { rating in
//        self.ratingDict ["criticalRate"] = Int(rating)
//      }
    }
  }
  @IBOutlet weak var visualEffectView: UIVisualEffectView! 
  @IBOutlet weak var teamTableView: UITableView!{
  didSet{
  teamTableView.dataSource = self
  teamTableView.delegate = self
  }
}
  var effect :UIVisualEffect!
    override func viewDidLoad() {
        super.viewDidLoad()
      
      effect = visualEffectView.effect
      //visualEffectView.effect = nil
     visualEffectView.isHidden = true
      ratingView.layer.cornerRadius = 5
      
    }

  
  func setupViewUI(){
    if i == 0{
      ratingButton.setTitle("Next", for: .normal)
      cosomosRateView.isHidden = false
      commentTextField.isHidden = true
    }
    cosomosRateView.rating = 0.0
     categoryLabel.text = categories[i]
    cosomosRateView.didFinishTouchingCosmos = { rating in
      self.ratingDict [self.categories[self.i]] = Int(rating)
    }
  }
  func animateIn() {
    
    visualEffectView.isHidden = false
    self.view.addSubview(ratingView)
    
   setupViewUI()
    ratingView.center = self.view.center
    
    ratingView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
    ratingView.alpha = 0
    
    UIView.animate(withDuration: 0.4) {
      self.visualEffectView.effect = self.effect
      self.ratingView.alpha = 1
      self.ratingView.transform = CGAffineTransform.identity
    }
    
  }
  
  
  func animateOut () {
     visualEffectView.isHidden = true
    UIView.animate(withDuration: 0.3, animations: {
      self.ratingView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
      self.ratingView.alpha = 0
      
      self.visualEffectView.effect = nil
      
    }) { (success:Bool) in
      self.ratingView.removeFromSuperview()
    }
  }
  
  @IBAction func ratingViewButtonClicked(_ sender: Any) {
    if cosomosRateView.rating != 0.0{
      i+=1
    if i == 6{
      print(ratingDict)
      animateOut()
    }else
    if i == 5 {
       ratingButton.setTitle("Submit", for: .normal)
      cosomosRateView.isHidden = true
      commentTextField.isHidden = false
      setupViewUI()
    }else{
  
    setupViewUI()
   
  }
  }
  }
  
  
}
extension TeamVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
    cell.textLabel?.text = "Name"
    cell.accessoryType = .none
    return cell
  }
  
}
extension TeamVC : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let cell = tableView.cellForRow(at: indexPath)
    i = 0
    setupViewUI()
    if cell?.accessoryType == UITableViewCellAccessoryType.none{
    animateIn()
    }
    cell?.accessoryType = .checkmark
  }
}
