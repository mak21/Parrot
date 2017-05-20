//
//  ProjectsVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class ProjectsVC: UIViewController {
var projects :[Any] = []
  var idsDict : [String: Int] = [:]
  
  @IBOutlet weak var projectsTableView: UITableView!{
    didSet{
      projectsTableView.register(ProjectCell.cellNib, forCellReuseIdentifier: ProjectCell.cellIdentifier)
      projectsTableView.dataSource = self
      projectsTableView.delegate = self
      projectsTableView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
      projectsTableView.separatorStyle = .none
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()
    
 //navigationController?.navigationBar.barTintColor = UIColor.red
    navigationController?.navigationBar.barTintColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
      navigationController?.view.backgroundColor = UIColor.clear
      navigationController?.navigationBar.isTranslucent = true
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    projects.removeAll()
     fetchProjects()
  }
  func fetchProjects(){
    
    guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
    
    let url = URL(string: "http://192.168.1.45:3001/api/v1/projects?private_token=\(validToken)")
    
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
            
            for project in validJSON{
              self.projects.append(project["name"] ?? "No data")
              
              
                self.idsDict[(project["name"] as? String)!] = project["id"] as? Int
              
            }
            // self.attendances = validJSON
            DispatchQueue.main.async {
              self.projectsTableView.reloadData()
            }
            
          } catch _ as NSError {
            
          }
          
        }
      }
      
    }
    
    dataTask.resume()
    
    
  }
  
}

extension ProjectsVC : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return projects.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectCell.cellIdentifier, for: indexPath) as? ProjectCell else {  return UITableViewCell()}
    cell.projectNameLabel.text = projects[indexPath.row] as? String
    //layout
    cell.backgroundColor = .clear
    cell.contentView.backgroundColor = .clear
    cell.containerView.backgroundColor = .white
    cell.containerView.layer.cornerRadius = 8.0
    cell.containerView.layer.masksToBounds = true
    return cell
  }
  
}
extension ProjectsVC : UITableViewDelegate{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 135
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamVC")as! TeamVC
    
   controller.groupId = self.idsDict[projects[indexPath.row] as! String]!
    present(controller, animated: true, completion: nil)
    
    
  }
}
