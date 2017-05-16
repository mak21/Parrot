//
//  ProjectsVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class ProjectsVC: UIViewController {

  @IBOutlet weak var projectsTableView: UITableView!{
    didSet{
      projectsTableView.dataSource = self
      projectsTableView.delegate = self
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  
}
extension ProjectsVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
    cell.textLabel?.text = "project Name"
    return cell
  }
  
}
extension ProjectsVC : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamVC")as! TeamVC
    navigationController?.pushViewController(controller, animated: true)
  }
}
