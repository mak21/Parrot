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
      feedTableView.dataSource = self
      feedTableView.delegate = self
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 

}
extension FeedVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 0
    
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.cellIdentifier, for: indexPath) as? FeedCell else {  return UITableViewCell()}
    
    return cell
  }
  
}
extension FeedVC : UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 115
  }
}
