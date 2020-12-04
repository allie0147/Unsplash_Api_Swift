//
//  UserListTableViewCell.swift
//  Unsplash_API
//
//  Created by Allie Kim on 2020/12/04.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblPhotos: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.contentView.autoresizingMask = .flexibleHeight
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
        // Configure the view for the selected state
    }
}
