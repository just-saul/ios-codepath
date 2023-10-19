//
//  PostCell.swift
//  ios101-project5-tumblr
//
//  Created by Saul Rios on 10/18/23.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
