//
//  RewordsVC.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/18/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class RewordsVC: UIViewController {
var is1Tapped = true
var is2Tapped = true
var is3Tapped = true
  
  @IBOutlet weak var gift1ImageView: UIImageView!{
    didSet{
      let gift1Gesture = UITapGestureRecognizer(target: self, action: #selector(gift1Tapped(_:)))
      gift1ImageView.addGestureRecognizer(gift1Gesture)
      gift1ImageView.isUserInteractionEnabled = true
    }
  }
  @IBOutlet weak var gift2ImageView: UIImageView!{
    didSet{
      let gift2Gesture = UITapGestureRecognizer(target: self, action: #selector(gift2Tapped(_:)))
      gift2ImageView.addGestureRecognizer(gift2Gesture)
      gift2ImageView.isUserInteractionEnabled = true
    }
  }
  @IBOutlet weak var gift3ImageView: UIImageView!{
    didSet{
      let gift3Gesture = UITapGestureRecognizer(target: self, action: #selector(gift3Tapped(_:)))
      gift3ImageView.addGestureRecognizer(gift3Gesture)
      gift3ImageView.isUserInteractionEnabled = true
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.gift1ImageView.frame = CGRect(x: 39, y: 394, width: 100, height: 100)
    self.gift3ImageView.frame = CGRect(x: 220, y: 394, width: 100, height: 100)
    self.gift1ImageView.isHidden = false
    self.gift2ImageView.isHidden = false
    self.gift3ImageView.isHidden = false
    self.gift1ImageView.image = #imageLiteral(resourceName: "gift")
    self.gift2ImageView.image = #imageLiteral(resourceName: "gift")
    self.gift3ImageView.image = #imageLiteral(resourceName: "gift")
  }
  func gift1Tapped(_ gesture : UITapGestureRecognizer){
    transform1toCenter()
    UIView.transition(with: gift1ImageView, duration: 2.0, options: .transitionFlipFromRight, animations: {
      //move to center
      
      if(self.is1Tapped){
        self.gift1ImageView.image = #imageLiteral(resourceName: "starbucks")
        self.is1Tapped = !self.is1Tapped
      }else{
        self.gift1ImageView.image = #imageLiteral(resourceName: "gift")
        self.is1Tapped = !self.is1Tapped
      }
      self.gift2ImageView.isHidden = true
      self.gift3ImageView.isHidden = true
    }, completion: nil)
     
    
  }
  func gift2Tapped(_ gesture : UITapGestureRecognizer){
    
    UIView.transition(with: gift2ImageView, duration: 2.0, options: .transitionFlipFromRight, animations: {
      if(self.is2Tapped){
        self.gift2ImageView.image = #imageLiteral(resourceName: "starbucks")
        self.is2Tapped = !self.is2Tapped
      }else{
        self.gift2ImageView.image = #imageLiteral(resourceName: "gift")
        self.is2Tapped = !self.is2Tapped
      }
      self.gift1ImageView.isHidden = true
      self.gift3ImageView.isHidden = true
    }, completion: nil)
    
    
  }
  func gift3Tapped(_ gesture : UITapGestureRecognizer){
    transform3toCenter()
    UIView.transition(with: gift3ImageView, duration: 2.0, options: .transitionFlipFromRight, animations: {
      if(self.is3Tapped){
        self.gift3ImageView.image = #imageLiteral(resourceName: "starbucks")
        self.is3Tapped = !self.is3Tapped
      }else{
        self.gift3ImageView.image = #imageLiteral(resourceName: "gift")
        self.is3Tapped = !self.is3Tapped
      }
      self.gift1ImageView.isHidden = true
      self.gift2ImageView.isHidden = true
    }, completion: nil)
    
    
  }
  func transform1toCenter(){
    UIView.animate(withDuration: 1.0, delay: 0.0, options: [.transitionCurlDown], animations: {
      self.gift1ImageView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 150, height: 150)
      self.gift1ImageView.center = self.view.center
    }, completion: nil)
  }
  func transform3toCenter(){
    UIView.animate(withDuration: 1.0, delay: 0.0, options: [.transitionCurlDown], animations: {
      self.gift3ImageView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 150, height: 150)
      self.gift3ImageView.center = self.view.center
    }, completion: nil)
  }

}
