//
//  CollectionViewCell.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/20/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var teammateImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teammateImage.image = nil
    }
}
