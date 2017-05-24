//
//  ProjectsVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/16/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class ProjectsVC: UIViewController {
  //var projects :[Any] = []
  var projects : [Project] = []
  //var projects :[Any] = ["project1","project2","project3"]
  var idsDict : [String: Int] = [:]
  @IBOutlet var projectView: UIView!
  @IBOutlet weak var visualEffectView: UIVisualEffectView!

  
  @IBOutlet weak var projectsTableView: UITableView!{
    didSet{
      projectsTableView.register(ProjectCell.cellNib, forCellReuseIdentifier: ProjectCell.cellIdentifier)
      projectsTableView.dataSource = self
      projectsTableView.delegate = self
      projectsTableView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
      projectsTableView.separatorStyle = .none
      
      projectsTableView.estimatedRowHeight = 135
      projectsTableView.rowHeight = UITableViewAutomaticDimension
    }
  }
  var effect :UIVisualEffect!
    override func viewDidLoad() {
        super.viewDidLoad()
     
      
      //self.navigationItem.titleView = UIImageView(image: logoImage)
    
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
            
            for projects in validJSON{
              
              let project = Project(dictionary: projects)
              
              //self.projects.apped(project["name"] ?? "No data")
              self.projects.append(project)
              
                self.idsDict[(projects["name"] as? String)!] = projects["id"] as? Int
              
            }
            
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
   
    cell.projectNameLabel.text = projects[indexPath.row].name 
    guard let urls = projects[indexPath.row].profileImagesUrl else {
      return UITableViewCell()}
    if urls.count != 0 {
    for  i in 0...4  {
      if i < urls.count{
     cell.membersImages[i].loadImageUsingCacheWithUrlString(urls[i])
      }
    }
    }
    cell.createdDateLabel.text = projects[indexPath.row].dateCreated! + " - " + projects[indexPath.row].dateEnded!
    
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
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 135
//  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamVC")as! TeamVC
    tableView.deselectRow(at: indexPath, animated: true)
   
    controller.groupId = self.projects[indexPath.row].id ?? 0
    guard let start =  projects[indexPath.row].dateCreated,
    let end = projects[indexPath.row].dateEnded,
    let client = projects[indexPath.row].client,
    let projectName = projects[indexPath.row].name else {return}
    
    controller.projectDate = start + " - " + end
    controller.clientName = client
    controller.projectName = projectName
    navigationController?.pushViewController(controller, animated: true)
    
    
  }
}
