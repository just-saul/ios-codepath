//
//  ViewControllerDetail.swift
//  ios101-project5-tumblr
//
//  Created by Saul Rios on 10/23/23.
//

import Foundation
import UIKit
import Nuke

class DetailViewController: UIViewController {
    
    @IBOutlet weak var postDetailImageView: UIImageView!
    @IBOutlet weak var postDetailTextView: UITextView!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        /// Set the post photo for the DetailViewController
        if let postDetailPhotoURL = post.photos.first {
            let photoURL = postDetailPhotoURL.originalSize.url
            
            Nuke.loadImage(with: photoURL, into: postDetailImageView)
        }
        
        /// Set the long caption for the DetailViewController
        postDetailTextView.text = post.caption.trimHTMLTags()
    }
}
