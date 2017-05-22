//
//  FeedVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
  @IBOutlet weak var feedTableView: UITableView!{
    didSet{
      feedTableView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
      feedTableView.separatorStyle = .none
      feedTableView.register(PostCell.cellNib, forCellReuseIdentifier: PostCell.cellIdentifier)
      feedTableView.register(FeedCell.cellNib, forCellReuseIdentifier: FeedCell.cellIdentifier)
      feedTableView.dataSource = self
      feedTableView.delegate = self
    }
  }
  var refresher :UIRefreshControl = UIRefreshControl()
  var feeds :[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      feedTableView.refreshControl = refresher
      refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
      refresher.tintColor = UIColor.orange
      
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    feeds.removeAll()
    fetchFeedback()
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  func refreshData(){
    feeds.removeAll()
    fetchFeedback()
    refresher.endRefreshing()
  }
 
//MARK: fetching data
  func fetchFeedback(){
    guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
    
    let url = URL(string: "http://192.168.1.122:3000/api/v1/feedbacks?private_token=\(validToken)")
    
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
            
            for feed in validJSON{
              self.feeds.append(feed["feed"] as? String ?? "No data")
            
            }
              
            
            
            DispatchQueue.main.async {
              self.feedTableView.reloadData()
            }
            
          } catch _ as NSError {
            
          }
          
        }
      }
      
    }
    
    dataTask.resume()
    
    
  
  }
 //MARK: Like Animation
  fileprivate func generateAnimatedViews(cellLocation: CGPoint, imageLocation:CGPoint){
  
    let image = drand48() > 0.5 ? #imageLiteral(resourceName: "thumbs_up") : #imageLiteral(resourceName: "heart")
    let imageView = UIImageView(image: image)
    let dimension = 20 + drand48() * 10  //drand48()give randomnumber from 0 to 1
    imageView.frame = CGRect(x: 0, y: 0, width: dimension , height: dimension)
    let animation = CAKeyframeAnimation(keyPath: "position")
    animation.path = customPath(cellLocation: cellLocation, imageLocation: imageLocation).cgPath
    animation.duration = 2 + drand48() * 3
    animation.fillMode = kCAFillModeForwards
    
    animation.isRemovedOnCompletion = false
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    imageView.layer.add(animation, forKey: nil)
    
    view.addSubview(imageView)
    
    //animation.delegate = self
  }
  func customPath(cellLocation:CGPoint,imageLocation:CGPoint)->UIBezierPath{
  let path = UIBezierPath()
    
  //path.move(to: CGPoint(x: 14, y: cellLocation.y + 71))
  path.move(to: CGPoint(x: imageLocation.x, y: cellLocation.y + imageLocation.y))
  //let endPoint = CGPoint(x: 400, y: cellLocation.y + 71)
    print("ceel",cellLocation,"image",imageLocation)
    let endPoint = CGPoint(x: 400, y: cellLocation.y + imageLocation.y - 24)
  let randomYShift = 200 + drand48() * 300
    let cp1 = CGPoint(x: 100 , y: Double(cellLocation.y ) - randomYShift)
  let cp2 = CGPoint(x: 200 , y: Double(cellLocation.y ) + randomYShift)
  
  path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
  return path
}
  
}
extension FeedVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return feeds.count + 1
    
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0{
      guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.cellIdentifier, for: indexPath) as? PostCell else {  return UITableViewCell()}
      cell.selectionStyle = .none
      //cell.profileImageView.loadImageUsingCacheWithUrlString()
      cell.delegate = self
      //layout
      cell.backgroundColor = .clear
      cell.contentView.backgroundColor = .clear
      cell.containerView.backgroundColor = .white
      cell.containerView.layer.cornerRadius = 8.0
      cell.containerView.layer.masksToBounds = true
      return cell
    }
    else{
      guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.cellIdentifier, for: indexPath) as? FeedCell else {  return UITableViewCell()}
      cell.selectionStyle = .none
      
      cell.feedLabel.text = feeds[indexPath.row - 1] // to start from index 0
      cell.delegate = self
      cell.backgroundColor = .clear
      cell.contentView.backgroundColor = .clear
      cell.containerView.backgroundColor = .white
      cell.containerView.layer.cornerRadius = 8.0
      cell.containerView.layer.masksToBounds = true
      return cell
    }
  
  }
  
  
}
extension FeedVC : UITableViewDelegate{
 
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 160
  }
}
extension FeedVC : FeedCellDelegate{
  func didSelectThumbUp(isTapped: Bool, cellLocation: CGPoint, imageLocation: CGPoint) {
    if isTapped{
      (0...10).forEach { (_) in
        generateAnimatedViews(cellLocation: cellLocation, imageLocation: imageLocation)
      }
    }
  }
 
}
extension FeedVC: PostCellDelegate{
  func didPost(isTapped: Bool) {
    if isTapped{
      feeds.removeAll()
      fetchFeedback()
    }
  }
}


