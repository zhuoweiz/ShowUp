//
//  Reaction.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/7/22.
//

import Foundation
import Firebase

struct Reaction: Identifiable {
    let id: String?
    
    let postID: String?
    let habitID: String?
    let guestUID: String?
    let title: String?
    let creationDate: Date?
    
    init() {
        id = ""
        postID = ""
        habitID = ""
        guestUID = ""
        title = ""
        creationDate = Date()
    }
    
    init(id: String, data: [String: Any]) {
        //
        self.id = id;
        
        postID = data["post_id"] as? String ?? ""
        guestUID = data["guest_uid"] as? String ?? ""
        habitID = data["habit_id"] as? String ?? ""
        title = data["title"] as? String ?? ""
        
        let tmpTime = data["creation_date"] as? Timestamp
        creationDate = tmpTime?.dateValue() ?? Date()
    }
}
