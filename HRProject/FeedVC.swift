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
      feedTableView.register(PostCell.cellNib, forCellReuseIdentifier: PostCell.cellIdentifier)
      feedTableView.register(FeedCell.cellNib, forCellReuseIdentifier: FeedCell.cellIdentifier)
      feedTableView.dataSource = self
      feedTableView.delegate = self
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    let endPoint = CGPoint(x: 400, y: cellLocation.y + imageLocation.y)
  let randomYShift = 200 + drand48() * 300
    let cp1 = CGPoint(x: 100 , y: Double(cellLocation.y) - randomYShift)
  let cp2 = CGPoint(x: 200 , y: Double(cellLocation.y) + randomYShift)
  
  path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
  return path
}
  
}
extension FeedVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 15 // number of posts +1 (1 for MynewPost)
    
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0{
      guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.cellIdentifier, for: indexPath) as? PostCell else {  return UITableViewCell()}
      cell.selectionStyle = .none
      return cell
    }
    else{
      guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.cellIdentifier, for: indexPath) as? FeedCell else {  return UITableViewCell()}
      cell.selectionStyle = .none
      cell.delegate = self
      return cell
    }
  
  }
  
  
}
extension FeedVC : UITableViewDelegate{
 
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 115
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


