//
//  UserCell.swift
//  GithubSearchUser
//
//  Created by Jinho Jang on 2020/10/20.
//

import UIKit
import Alamofire

class UserCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numberOfReposLabel: UILabel!
    
    var user: User? {
        didSet {
            self.avatarImage.kf.setImage(with: URL(string: user?.avatarURL ?? ""))
            self.usernameLabel.text = user?.login
            self.numberOfReposLabel.text = "Number of repose: " + String(user?.numberOfRepos ?? -1)
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "UserCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
