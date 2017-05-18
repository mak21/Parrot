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
  var currentProjectId : Int = 0
  var membersDict : [String:Any] = [:]
  var ratingDict : [String:Any] = ["positive_attitude":0,"creativity":0,"responsibility":0,"teamwork":0,"critical_thinking":0,"comment":""]
  var categories = ["positive_attitude","creativity","responsibility","teamwork","critical_thinking", "comment"]
  var i = 0
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var ratingButton: UIButton!
  @IBOutlet var ratingView: UIView!

  @IBOutlet weak var commentTextView: UITextView!
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
    teamTableView.register(TeamCell.cellNib, forCellReuseIdentifier: TeamCell.cellIdentifier)
  teamTableView.dataSource = self
  teamTableView.delegate = self
  }
}
  var effect :UIVisualEffect!
    override func viewDidLoad() {
        super.viewDidLoad()
      profileImageView.circlerImage()
      effect = visualEffectView.effect
      //visualEffectView.effect = nil
     visualEffectView.isHidden = true
      ratingView.layer.cornerRadius = 5
      ratingButton.layer.cornerRadius = 15
      ratingButton.layer.masksToBounds = true
      
    }

  
  func setupViewUI(){
    if i == 0{
      ratingButton.setTitle("Next", for: .normal)
      cosomosRateView.isHidden = false
      commentTextView.isHidden = true
    
    }
    cosomosRateView.rating = 0.0
     categoryLabel.text = categories[i]
    cosomosRateView.didFinishTouchingCosmos = { rating in
      self.ratingDict [self.categories[self.i]] = Int(rating)
    }
    if self.categories[self.i] == "comment"{
      
      self.ratingDict [self.categories[self.i]] = self.commentTextView.text
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
    
    if cosomosRateView.rating != 0.0 || commentTextView.text != ""{
      i+=1
      
    if i == 6{
      
      
      i = 5
      setupViewUI()
      print(ratingDict)
      
      sendRating()
      animateOut()
    }else
    if i == 5 {
       ratingButton.setTitle("Submit", for: .normal)
      cosomosRateView.isHidden = true
      commentTextView.isHidden = false
      setupViewUI()
//    }else if i == 6 {
//      i = 5
//      setupViewUI()
//    }
    }else{
  
    setupViewUI()
   
  }
  }
  }
  
  func sendRating() {
    guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
    
    let url = URL(string: "http://192.168.1.122:3000/api/v1/projects/\(currentProjectId)?private_token=/\(validToken)")
    var urlRequest = URLRequest(url: url!)
    
    urlRequest.httpMethod = "PUT"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
    
    
    var data: Data?
    do {
      
      data = try JSONSerialization.data(withJSONObject: self.ratingDict, options: .prettyPrinted)
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    
    urlRequest.httpBody = data
    
    
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
      
      
      if let validError = error {
        print(validError.localizedDescription)
      }
      
      
      if let httpResponse = response as? HTTPURLResponse {
        
        if httpResponse.statusCode == 200 {
          
          do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
            
            
          } catch let jsonError as NSError {
            
          }
          
        }
      }
      
    }
    
    dataTask.resume()
    
    
  }
}
extension TeamVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
   return membersDict.keys.count / 2
  
   
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.cellIdentifier, for: indexPath) as? TeamCell else {  return UITableViewCell()}
    cell.nameLabel.text = membersDict["name"] as! String
    guard let url = membersDict["image"] else{return UITableViewCell()}
  cell.profileImageView.loadImageUsingCacheWithUrlString(url as! String)
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
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 85
  }
}
