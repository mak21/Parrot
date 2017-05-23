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
  let transition = CircularTransition()
  @IBOutlet weak var positive_attitudeView: CosmosView!
  @IBOutlet weak var critical_thinkingView: CosmosView!
  @IBOutlet weak var teamworkView: CosmosView!
  @IBOutlet weak var responsibilityView: CosmosView!
  @IBOutlet weak var creativityView: CosmosView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var clientLabel: UILabel!
  @IBOutlet weak var projectNameLabel: UILabel!
  var projectDate = ""
  var projectName = ""
  var clientName = ""
  var comments: [String] = []
    var members : [Member] = []
  var groupId : Int = 0
  
  var ratingDict : [String:Any] = ["positive_attitude":0,"creativity":0,"responsibility":0,"teamwork":0,"critical_thinking":0,"comment":""]
  var categories = ["positive_attitude","creativity","responsibility","teamwork","critical_thinking", "comment"]
  var bigCategories = ["Positive Attitude","Creativity","Responsibility","Teamwork","Critical Thinking", "Comment"]
  var i = 0
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var ratingButton: UIButton!
  @IBOutlet var ratingView: UIView!
 @IBOutlet weak var commentButton: UIButton!
  @IBOutlet weak var commentTextView: UITextView!{
    didSet{
      commentTextView.delegate = self
    }
  }
  @IBOutlet weak var selectedPersonNameLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var cosomosRateView: CosmosView!
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
      setupNav()
      commentButton.layer.masksToBounds = false
      commentButton.addTarget(self, action: #selector(commentsButtonTapped), for: .touchUpInside)
      profileImageView.circlerImage()
      effect = visualEffectView.effect
     visualEffectView.isHidden = true
      ratingView.layer.cornerRadius = 5
      ratingButton.layer.cornerRadius = 15
      ratingButton.layer.masksToBounds = true
      
      dateLabel.text = projectDate
      projectNameLabel.text =  projectName
      clientLabel.text =  clientName
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.tintColor = UIColor.white
    fetchMembers(groupId: groupId)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    members.removeAll()
    comments.removeAll()
  }
  
  func setupNav(){
    let titleView = UIView()
    titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    //titleView.backgroundColor = UIColor.red
    
    let containerView = UIView()
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    titleView.addSubview(containerView)
    
    let profileImageView = UIImageView()
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.layer.cornerRadius = 17.5
    profileImageView.clipsToBounds = true
    profileImageView.image  = #imageLiteral(resourceName: "logo parrot brush")
    
    containerView.addSubview(profileImageView)
    profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 170).isActive = true
    
    profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
    containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
    
    
    self.navigationItem.titleView = titleView
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  //MARK: comment Button Animation
  func commentsButtonTapped(){
    let commentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVC")as! CommentsVC
    commentVC.transitioningDelegate = self
    commentVC.modalPresentationStyle = .custom
    for i in 0...comments.count{
      if comments[i] == "" {
        comments.remove(at: i)
      }
    }
//    for c in self.comments{
//      if c == "" {
//        
//        self.comments.filter({ (c) -> Bool in
//          c != ""
//        })
//      }
//    }
    commentVC.comments = self.comments
    present(commentVC, animated: true, completion: nil)
  }
  
  func fetchMembers(groupId : Int){
    
    guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
    
    let url = URL(string: "http://192.168.1.122:3000/api/v1/projects/\(groupId)?private_token=\(validToken)")
    
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
            
            guard let validJSON = jsonResponse as? [[String:Any]] else { return }
            
            for d in validJSON {
              
              let member = Member(d: d)
              
              self.members.append(member)
              
               let comment = d["comment"] as? [String] ?? [""]
              
              print("comment",comment,"\n d[comment]")
              for i in comment{
                  self.comments.append(i)
              }
            
            }
            
            let ratingsDict = validJSON.last
            
            guard let paAVG = ratingsDict?["positive_attitude_ave"] as? Int,
            let ctAVG = ratingsDict?["critical_thinking_ave"] as? Int,
           let  cAVG = ratingsDict?["creativity_ave"] as? Int,
           let  rAVG = ratingsDict?["responsibility_ave"] as? Int,
            let  tAVG = ratingsDict?["teamwork_ave"] as? Int else{return}
            DispatchQueue.main.async {
              self.teamTableView.reloadData()
              self.positive_attitudeView.rating = Double(paAVG)
              self.creativityView.rating = Double(cAVG)
              self.teamworkView.rating = Double(tAVG)
              self.responsibilityView.rating = Double(rAVG)
              self.critical_thinkingView.rating = Double(ctAVG)
            }
          } catch _ as NSError {
            
          }
          
        }
      }
      
    }
    
    dataTask.resume()
  }
  func setupViewUI(){
    
    if i == 0{
      ratingButton.setTitle("Next", for: .normal)
      cosomosRateView.isHidden = false
      commentTextView.isHidden = true
    
    }
    cosomosRateView.rating = 0.0
     categoryLabel.text = bigCategories[i]
    cosomosRateView.didFinishTouchingCosmos = { rating in
      self.ratingDict [self.categories[self.i]] = Int(rating)
    }
    if self.categories[self.i] == "comment"{
      
      self.ratingDict [self.categories[self.i]] = self.commentTextView.text
      commentTextView.text = "Please leave a comment..."
      commentTextView.textColor = UIColor.darkGray
      self.ratingDict["status"] = true
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
     navigationController?.navigationBar.isHidden = false
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
      
      let alert: UIAlertController = UIAlertController(title: "Thank You", message: "You received 10 points for your rating check your points for redemption", preferredStyle: .alert)
    
      let cancleAction = UIAlertAction(title: "Close", style: .default, handler: {(alert: UIAlertAction) in
      self.animateOut()
   
      })
      
      alert.addAction(cancleAction)
      self.present(alert, animated: true, completion: nil)
      //self.animateOut()
     
    }else
    if i == 5 {
       ratingButton.setTitle("Submit", for: .normal)
      cosomosRateView.isHidden = true
      commentTextView.isHidden = false
      setupViewUI()

    }else{
  
    setupViewUI()
   
  }
  }
  }
  
  func sendRating() {
    guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
    
    let url = URL(string: "http://192.168.1.122:3000/api/v1/projects/\(groupId)?private_token=\(validToken)")
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
            _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
          } catch _ as NSError {
            
          }
          
        }
      }
      
    }
    dataTask.resume()
  }
}
extension TeamVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
   return members.count
  
   
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.cellIdentifier, for: indexPath) as? TeamCell else {  return UITableViewCell()}
    
    cell.nameLabel.text = members[indexPath.row].name
    
    guard let url = members[indexPath.row].profileImageUrl else{return UITableViewCell()}
  cell.profileImageView.loadImageUsingCacheWithUrlString(url)
    cell.accessoryType = .none
    return cell
  }
  
}
extension TeamVC : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let cell = tableView.cellForRow(at: indexPath)
    i = 0
    
    self.ratingDict["ratee_id"] = members[indexPath.row].id
    setupViewUI()
    selectedPersonNameLabel.text = members[indexPath.row].name
    
    guard let url = members[indexPath.row].profileImageUrl else{return}
    profileImageView.loadImageUsingCacheWithUrlString(url)
    if cell?.accessoryType == UITableViewCellAccessoryType.none{
    animateIn()
      
    }
    
    //animateIn() //remove it
    cell?.accessoryType = .checkmark
    tableView.deselectRow(at: indexPath, animated: true)
   navigationController?.navigationBar.isHidden = true
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 85
  }
}
extension TeamVC: UITextViewDelegate{
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if commentTextView.textColor == UIColor.darkGray {
      commentTextView.text = nil
      commentTextView.textColor = UIColor.black
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if commentTextView.text.isEmpty {
      commentTextView.text = "Placeholder"
      commentTextView.textColor = UIColor.darkGray
      
    }
}
  
}
extension TeamVC: UIViewControllerTransitioningDelegate {
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
