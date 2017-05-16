//
//  TeamVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class TeamVC: UIViewController {

  @IBOutlet weak var teamTableView: UITableView!{
  didSet{
  teamTableView.dataSource = self
  teamTableView.delegate = self
  }
}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  

  
}
extension TeamVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
    cell.textLabel?.text = "Name"
    return cell
  }
  
}
extension TeamVC : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingVC")as! RatingVC
    navigationController?.pushViewController(controller, animated: true)
  }
}
