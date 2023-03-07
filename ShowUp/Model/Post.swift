//
//  Post.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import Foundation
import FirebaseFirestore
import UIKit


struct Post: Identifiable {
    let id: String?
    
    let habitID: String?
    let title: String?
    let postDate: Date?
    var image: UIImage? = nil
    
    init() {
        id = "1";
        habitID = "";
        title = "DEFAULT_TITLE"
        postDate = Date()
    }
    
    
    init(id: String, habitID: String, data: [String: Any]) {
        //
        self.id = id;
        self.habitID = habitID
        
        title = data["title"] as? String ?? "DEFAULT_TITLE"
        let tmpTime = data["post_date"] as? Timestamp
        postDate = tmpTime?.dateValue() ?? Date()
    }
    
    init(id: String, data: [String: Any]) {
        //
        self.id = id;
        self.habitID = data["habit_id"] as? String ?? ""
        
        title = data["title"] as? String ?? "DEFAULT_TITLE"
        let tmpTime = data["post_date"] as? Timestamp
        postDate = tmpTime?.dateValue() ?? Date()
    }
}
