//
//  ProfileVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Cosmos
class ProfileVC: UIViewController{
 let transition = CircularTransition()
  
  
  @IBOutlet weak var positive_attitudeView: CosmosView!
  @IBOutlet weak var critical_thinkingView: CosmosView!
  @IBOutlet weak var teamworkView: CosmosView!
  @IBOutlet weak var responsibilityView: CosmosView!
  @IBOutlet weak var creativityView: CosmosView!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var depLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var commentButton: UIButton!
  var ratings : [Rate] = []
  var comments: [String] = []
  var positive_attitudeSum = 0.0
  var creativitySum = 0.0
  var responsibilitySum = 0.0
  var teamworkSum = 0.0
  var critical_thinkingSum = 0.0
  var currentUser : Member!
    override func viewDidLoad() {
        super.viewDidLoad()
    
      setupUI()
      profileImage.circlerImage()
      profileImage.layer.borderWidth = 3.0
      profileImage.layer.borderColor = UIColor.orange.cgColor
     
     
    }
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    ratings.removeAll()
    comments.removeAll()
    positive_attitudeSum = 0.0
    creativitySum = 0.0
    responsibilitySum = 0.0
    teamworkSum = 0.0
    critical_thinkingSum = 0.0
    fetchUserData()
  }
 
  @IBAction func logOutButtonTapped(_ sender: Any) {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "AUTH_TOKEN")
    defaults.synchronize()
    let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC")
    present(controller, animated: true, completion: nil)
  }
  func setupUI(){
    // shadow for glowing 
    commentButton.layer.shadowColor = UIColor.blue.cgColor
    commentButton.layer.shadowRadius = 4.0
    commentButton.layer.shadowOpacity = 0.4
    commentButton.layer.shadowOffset = CGSize.zero
    //
    commentButton.layer.masksToBounds = false
    commentButton.addTarget(self, action: #selector(commentsButtonTapped), for: .touchUpInside)
    positive_attitudeView.settings.fillMode = .half
    teamworkView.settings.fillMode = .half
    responsibilityView.settings.fillMode = .half
    creativityView.settings.fillMode = .half
    critical_thinkingView.settings.fillMode = .half

  }
  func fetchUserData(){
    
    guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
    
    let url = URL(string: "http://192.168.1.45:3001/api/v1/users/0?private_token=\(validToken)")
    
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
    
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
      
      
      if let validError = error {
        
        print(validError.localizedDescription)
      }
      
      
      if let httpResponse = response as? HTTPURLResponse {
        
        if httpResponse.statusCode == 200 {
          
          do {
            
            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print (jsonResponse)
            
            // U might need to do some changes here!!
            guard let validJSON = jsonResponse as? [String:Any] ,
           let ratingDicts =  validJSON["rating"] as? [[String:Any]],
            let userDict = validJSON["user"] as? [String:Any] else { return }
            
              self.currentUser = Member(dictionary: userDict)
            
            for r in ratingDicts{
              let rate = Rate(dictionary: r)
               self.ratings.append(rate)
            }
            
            DispatchQueue.main.async {
              //currentUser
              self.profileImage.loadImageUsingCacheWithUrlString(self.currentUser.profileImageUrl!)
              self.nameLabel.text = self.currentUser.name
              self.emailLabel.text = self.currentUser.email
              self.depLabel.text = self.currentUser.department
              self.titleLabel.text = self.currentUser.title
              //rating
              
              for r in self.ratings{
                
                self.comments.append(r.comment ?? "")
                
                self.positive_attitudeSum += Double(r.positive_attitude! )
                self.creativitySum += Double(r.creativity!)
                self.responsibilitySum += Double(r.responsibility!)
                self.teamworkSum += Double(r.teamwork!)
                
                self.critical_thinkingSum += Double(r.critical_thinking!)
              }
              
              self.positive_attitudeView.rating = self.positive_attitudeSum / Double(self.ratings.count)
              
              self.critical_thinkingView.rating = self.critical_thinkingSum / Double(self.ratings.count)
              self.teamworkView.rating = self.teamworkSum / Double(self.ratings.count)
              self.responsibilityView.rating = self.responsibilitySum / Double(self.ratings.count)
              self.creativityView.rating = self.creativitySum / Double(self.ratings.count)
            }
            
          } catch _ as NSError {
            
          }
          
        }
      }
      
    }
    
    dataTask.resume()
    
  }


//MARK: comment Button Animation
  func commentsButtonTapped(){
     let commentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVC")as! CommentsVC
    commentVC.transitioningDelegate = self
    commentVC.modalPresentationStyle = .custom
    commentVC.comments = self.comments
    present(commentVC, animated: true, completion: nil)
  }
}
extension ProfileVC: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.startingPoint = commentButton.center
  
    transition.circleColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)//commentButton.backgroundColor!
    
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint = commentButton.center
    transition.circleColor = UIColor.white//commentButton.backgroundColor!
    
    return transition
  }
}
