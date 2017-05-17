//
//  ProfileVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController{
 let transition = CircularTransition()
  @IBOutlet weak var commentButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      commentButton.addTarget(self, action: #selector(commentsButtonTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    let commentVC = segue.destination as! CommentsVC
//    commentVC.transitioningDelegate = self
//    commentVC.modalPresentationStyle = .custom
//  }
  func commentsButtonTapped(){
     let commentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVC")as! CommentsVC
    commentVC.transitioningDelegate = self
    commentVC.modalPresentationStyle = .custom
    present(commentVC, animated: true, completion: nil)
  }
  
  

}
extension ProfileVC: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.startingPoint = commentButton.center
  
    transition.circleColor = UIColor.red//commentButton.backgroundColor!
    
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint = commentButton.center
    transition.circleColor = UIColor.white//commentButton.backgroundColor!
    
    return transition
  }
}
