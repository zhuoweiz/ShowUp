//
//  Friend.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/7/22.
//

import Foundation
import Firebase

struct Friend: Identifiable {
    let id: String?
    
    var username: String = ""
    var authorImage: UIImage?  = nil
    
    init() {
        id = ""
    }
    
    init(id: String, data: [String: Any]) {
        //
        self.id = id;
        
        username = data["username"] as? String ?? ""
    }
}
