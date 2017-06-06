//
//  ProfileVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Cosmos
enum ProfileType {
  case myProfile
  case otherProfile
}
class ProfileVC: UIViewController{
 
  
  
  
  @IBOutlet weak var collectionView: UICollectionView!{
    didSet{
      collectionView.delegate = self
      collectionView.dataSource = self
      
    }
  }
  
  @IBOutlet weak var positive_attitudeView: CosmosView!
  @IBOutlet weak var critical_thinkingView: CosmosView!
  @IBOutlet weak var teamworkView: CosmosView!
  @IBOutlet weak var responsibilityView: CosmosView!
  @IBOutlet weak var creativityView: CosmosView!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  var profileType : ProfileType = .myProfile
  var ratings : [Rate] = []
  var teammatesIds : [Int] = []
  var teammatesUrls:[String] = []
  //var collectionviewLayout: CustomImageFlowLayout!
  var positive_attitudeSum = 0.0
  var creativitySum = 0.0
  var responsibilitySum = 0.0
  var teamworkSum = 0.0
  var critical_thinkingSum = 0.0
  var currentUser : Member!
    override func viewDidLoad() {
        super.viewDidLoad()
      //collectionviewLayout = CustomImageFlowLayout()
      //collectionView.collectionViewLayout = collectionviewLayout
     // collectionView.backgroundColor = .white
      setupUI()
      profileImage.circlerImage()
      profileImage.layer.borderWidth = 3.0
      profileImage.layer.borderColor = UIColor.orange.cgColor
      
     
    }
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
     configurProfileType(profileType)
    ratings.removeAll()
     teammatesIds.removeAll()
    teammatesUrls.removeAll()
    positive_attitudeSum = 0.0
    creativitySum = 0.0
    responsibilitySum = 0.0
    teamworkSum = 0.0
    critical_thinkingSum = 0.0
    fetchUserData()
  }
  func configurProfileType (_ type : ProfileType) {
    switch type {
    case .myProfile :
      
      configureMyProfile()
    case .otherProfile:
      
      configureOtherProfile()
    }
  }
  func configureMyProfile () {
    
//    let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
//    navigationItem.rightBarButtonItem = barButtonItem
//    editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
//    
//    if let id = currentUser?.uid {
//      print(id)
//      currentUserID = id
//    }
  }
  
  func configureOtherProfile () {
    
//    editButton.setTitle("Follow", for: .normal)
//    checkFollowing(sender: editButton)
//    editButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
  }
  
  @IBAction func logOutButtonTapped(_ sender: Any) {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "AUTH_TOKEN")
    defaults.synchronize()
    let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC")
    present(controller, animated: true, completion: nil)
  }
  func setupUI(){

   
    positive_attitudeView.settings.fillMode = .half
    teamworkView.settings.fillMode = .half
    responsibilityView.settings.fillMode = .half
    creativityView.settings.fillMode = .half
    critical_thinkingView.settings.fillMode = .half

  }
  func fetchUserData(){
    
    guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
    
    let url = URL(string: "https://parrotext.herokuapp.com/api/v1/users/0?private_token=\(validToken)")
    
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
           let userDict = validJSON["user"] as? [[String:Any]],
            let projectUsers = validJSON["project_users"] as? [[String:Any]] else { return }
            
           // for p in projectUsers{
              
            //  self.teammatesIds.append(p["id"] as! Int)
          
              for url in projectUsers.last?["urls"] as! [String]{
                
                self.teammatesUrls.append(url)
                
              }
              
            //}

           
            for u in userDict {
               self.currentUser = Member(d: u)
              
            }
           
            
            for r in ratingDicts{
              
              let rate = Rate(dictionary: r)
               self.ratings.append(rate)
            }
            
            DispatchQueue.main.async {
              //currentUser
              self.collectionView.reloadData()
              
              self.profileImage.loadImageUsingCacheWithUrlString(self.currentUser.profileImageUrl!)
              self.nameLabel.text = self.currentUser.name
              self.emailLabel.text = self.currentUser.email
            
              self.titleLabel.text = self.currentUser.title! + " at " + self.currentUser.department! + " department"
              //rating
              
              for r in self.ratings{
                
                //self.comments.append(r.comment ?? "")
                
                self.positive_attitudeSum += Double(r.positive_attitude! )
                self.creativitySum += Double(r.creativity!)
                self.responsibilitySum += Double(r.responsibility!)
                self.teamworkSum += Double(r.teamwork!)
                
                self.critical_thinkingSum += Double(r.critical_thinking!)
              }

              if self.ratings.count != 0{
              self.positive_attitudeView.rating = self.positive_attitudeSum / Double(self.ratings.count)
              
              self.critical_thinkingView.rating = self.critical_thinkingSum / Double(self.ratings.count)
              self.teamworkView.rating = self.teamworkSum / Double(self.ratings.count)
              self.responsibilityView.rating = self.responsibilitySum / Double(self.ratings.count)
              self.creativityView.rating = self.creativitySum / Double(self.ratings.count)
            }
            }
            
          } catch _ as NSError {
            
          }
          
        }
      }
      
    }
    
    dataTask.resume()
    
  }

}
extension ProfileVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return teammatesUrls.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    
  cell.teammateImage.loadImageUsingCacheWithUrlString(teammatesUrls[indexPath.row])
    
    
    
    return cell
    
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  // go to there profile
  }
}

