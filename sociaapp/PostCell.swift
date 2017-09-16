//
//  PostCell.swift
//  sociaapp
//
//  Created by HGPMAC58 on 7/24/17.
//  Copyright © 2017 HGPMAC58. All rights reserved.
//


import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper
import FirebaseStorageUI

class PostCell: UITableViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    var userPostKey: DatabaseReference!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configCell(post: Post) {
        print("===================================\(String(describing: currentUser))")
        self.post = post
        self.postImg.image = nil
        self.likesLbl.text = "\(post.likes)"
        
        // self.username.text = post.username
        
//        let userImage = post.userImg
        let url = URL(string: post.postImg!)!
        postImg.sd_setImage(with: url)
        
       _ = Database.database().reference().child("users").child(currentUser!).child("likes").child(post.postKey)
    }
    
    @IBAction func liked(_ sender: Any) {
        
        let likeRef = Database.database().reference().child("users").child(currentUser!).child("likes").child(post.postKey)
        
        likeRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                
                self.post.adjustLikes(addlike: true)
                
                likeRef.setValue(true)
                
            } else {
                
                self.post.adjustLikes(addlike: false)
                
                likeRef.removeValue()
            }
        })
    }
}
