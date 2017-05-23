//
//  SearchVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class SearchVC: UIViewController,UISearchBarDelegate {
    var users = [Member]()
    var filterdUsers = [Member]()
    
    @IBOutlet weak var friendsTableView: UITableView!{
        didSet{
         friendsTableView.register(TeamCell.cellNib, forCellReuseIdentifier: TeamCell.cellIdentifier)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
    
        friendsTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        friendsTableView.reloadData()
      
        setupSearchBar()
    }
    func setupSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
        searchBar.delegate = self
        self.friendsTableView.tableHeaderView = searchBar
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterdUsers = users
            self.friendsTableView.reloadData()
        }else {
            filterTableView(text: searchText)
        }
    }
    
    func filterTableView(text:String) {
        
            //fix of not searching when backspacing
            filterdUsers = users.filter({ (user) -> Bool in
                return (user.name?.lowercased().contains(text.lowercased()))!
            })
            self.friendsTableView.reloadData()
      
    }
    
    func fetchUser() {
      guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
      
      let url = URL(string: "http://192.168.1.122:3000/api/v1/users/0?private_token=\(validToken)")
      
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
              
              // U might need to do some changes here!!
              guard let validJSON = jsonResponse as? [String:Any] else {return}
       
              
              
              DispatchQueue.main.async {
             
              }
              
            } catch _ as NSError {
              
            }
            
          }
        }
        
      }
      
      dataTask.resume()
      
  }


}
extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return filterdUsers.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.cellIdentifier, for: indexPath) as? TeamCell else {  return UITableViewCell()}
       
        let user = filterdUsers[indexPath.row]
        cell.nameLabel.text = user.name
        
        if let profileImageUrl = user.profileImageUrl {
         print("userImage: ",user.profileImageUrl ?? "")
            cell.accessoryType = .none
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            cell.profileImageView.circlerImage()
                
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
       let selectedUser = users[indexPath.row]
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
        controller.profileType = .otherProfile
      tabBarController?.selectedIndex = 0
        
    }
    
}
