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
  var membersDic : [String : Any] = [:]
  @IBOutlet weak var projectsTableView: UITableView!{
    didSet{
      projectsTableView.dataSource = self
      projectsTableView.delegate = self
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchProjects()
    }

  func fetchProjects(){
    
    guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
    
    let url = URL(string: "http://192.168.1.122:3000/api/v1/projects?private_token=\(validToken)")
    
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
            
          } catch let jsonError as NSError {
            
          }
          
        }
      }
      
    }
    
    dataTask.resume()
    
    
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
            
            for project in validJSON{
              // i think this should be [[String:Any]] array of small dict
             self.membersDic["name"] = project["full_name"] as? String
              self.membersDic["id"] = project["id"] as? Int
              guard let images = project["avatar"] as? [String:Any] else{return }
              
              for image in (images["medium"] as? [String:Any])! {
                self.membersDic["image"] = image.value as! String
              }
            }
            
            DispatchQueue.main.async {
              
              self.projectsTableView.reloadData()
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamVC")as! TeamVC
              
                controller.membersDict = self.membersDic
               controller.currentProjectId = groupId
              self.navigationController?.pushViewController(controller, animated: true)
            }
            
          } catch let jsonError as NSError {
            
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
    cell.textLabel?.text = projects[indexPath.row] as! String
    return cell
  }
  
}
extension ProjectsVC : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamVC")as! TeamVC
    self.fetchMembers(groupId: self.idsDict[projects[indexPath.row] as! String]!)
   
    
   // controller.membersDict = membersDic
    
    //navigationController?.pushViewController(controller, animated: true)
  }
}
