//
//  CommentsVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/17/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController {
  @IBOutlet weak var commentsTableView: UITableView!{
    didSet{
      commentsTableView.register(CommentsCell.cellNib, forCellReuseIdentifier: CommentsCell.cellIdentifier)
      commentsTableView.dataSource = self
      commentsTableView.delegate = self
    }
  }
  var comments : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    comments.removeAll()
  }
  
    
  @IBAction func dissmisButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

}
extension CommentsVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return comments.count
    
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCell.cellIdentifier, for: indexPath) as? CommentsCell else {  return UITableViewCell()}
   cell.commentLabel.text = comments[indexPath.row]
    return cell
  }
  
}
extension CommentsVC : UITableViewDelegate{
 
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
}
