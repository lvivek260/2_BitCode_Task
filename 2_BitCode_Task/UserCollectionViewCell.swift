//
//  UserCollectionViewCell.swift
//  2_BitCode_Task
//
//  Created by Admin on 18/02/23.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        userImage.backgroundColor = .systemGray3
        userName.textColor = .black
        userName.textAlignment = .center
    }

}
