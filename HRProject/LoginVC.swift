//
//  LoginVC.swift
//  sampleApi
//
//  Created by mahmoud khudairi on 5/15/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    
    @IBOutlet weak var buttonLogin: UIButton! {
      didSet{
        buttonLogin.addTarget(self, action: #selector(login), for: .touchUpInside)
      }
    }
    
  override func viewWillAppear(_ animated: Bool) {
    if UserDefaults.standard.string(forKey: "AUTH_TOKEN") != nil{
      
      displayHome()
    }
  }
    override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
  
    }
    
  
    
    func login() {
      
      
      let username = "mak@gmail.com"
      let password = "1234567"
      
      
      let url = URL(string: "")
      var urlRequest = URLRequest(url: url!)
      
      urlRequest.httpMethod = "POST"
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
      
      let params :[String: String] = [
        "email" : username,
        "password" : password
      ]
      
      var data: Data?
      do {
        data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
      } catch let error as NSError {
        print(error.localizedDescription)
      }
      
      urlRequest.httpBody = data
      
      
      let urlSession = URLSession(configuration: URLSessionConfiguration.default)
      
      let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
        
        
        if let validError = error {
          print(validError.localizedDescription)
        }
        
        
        if let httpResponse = response as? HTTPURLResponse {
          
          if httpResponse.statusCode == 200 {
            
            do {
              let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
              
              
              guard let validJSON = jsonResponse as? [String:Any] else { return }
              
              
              UserDefaults.standard.setValue(validJSON["private_token"], forKey: "AUTH_TOKEN")
              UserDefaults.standard.synchronize()
              
              DispatchQueue.main.async {
                self.displayHome()
              }
              
              
              
              
              print(jsonResponse)
              
            } catch let jsonError as NSError {
              
            }
            
          }
        }
        
      }
      
      dataTask.resume()
      
      
    }
    
    
    func displayHome(){
      let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarController")
      
      present(controller, animated: true, completion: nil)
    }
    
    
  }
  

  


