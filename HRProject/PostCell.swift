//
//  PostCell.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/18/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
protocol PostCellDelegate: class {
  func didPost(isTapped: Bool)
  
}
class PostCell: UITableViewCell {
  @IBOutlet weak var postButton: UIButton!
  @IBOutlet weak var textView: UITextView!{
    didSet{
      textView.delegate = self
    }
  }
 
  @IBOutlet weak var profileImageView: UIImageView!
  static let cellIdentifier = "PostCell"
  static let cellNib = UINib(nibName: PostCell.cellIdentifier, bundle: Bundle.main)
   weak var delegate : PostCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
      setupPlaceHolder()
      profileImageView.circlerImage()
      postButton.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func setupPlaceHolder(){
    textView.text = "Whats on your mind?"
    textView.textColor = UIColor.lightGray
  }
  func handlePost(){
    
    guard let validToken = UserDefaults.standard.string(forKey: "AUTH_TOKEN") else { return }
    
    let url = URL(string: "http://192.168.1.45:3001/api/v1/feedbacks?private_token=\(validToken)")
    print(validToken)
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
    
    let params :[String: String] = [
      "feed" : textView.text
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
            _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            DispatchQueue.main.async {
              self.setupPlaceHolder()
            }
            DispatchQueue.main.async {
              self.delegate?.didPost(isTapped: true)
            }
          } catch _ as NSError {
          }
        }
      }
      
    }
    dataTask.resume()
    
  }
 
}
extension PostCell: UITextViewDelegate{
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "Placeholder"
      textView.textColor = UIColor.lightGray
    }
  }
  
}
