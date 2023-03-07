//
//  Habit.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import Foundation
import FirebaseFirestore
import Firebase
import UIKit

struct Habit: Identifiable {
    let id: String?
    
    let title: String?
    let author: String? // uid
    let desc: String?
    let frequency: Int?
    let duration: Int?
    let startDate: Date?
    
    var posts: [Post] = []
    
    // some additional vars for friend habit view
    var authorUsername: String = ""
    var authorImage: UIImage?  = nil
    
    init() {
        id = "1";
        title = "DEFAULT_TITLE"
        author = "DEFAULT_ID"
        desc = "DEFAULT_DESC"
        frequency = 0
        duration = 1
        startDate = Date()
    }
    
    init(id: String, data: [String: Any]) {
        //
        self.id = id;
        let authorRef: DocumentReference = data["author"] as! DocumentReference
        
        title = data["title"] as? String ?? "DEFAULT_TITLE"
        author = authorRef.path.components(separatedBy: "/")[1]
        
        desc = data["desc"] as? String ?? "DEFAULT_DESC"
        frequency = data["frequency"] as? Int ?? 1
        duration = data["duration"] as? Int ?? 1
        let tmpTime = data["start_date"] as? Timestamp
        startDate = tmpTime?.dateValue() ?? Date()
    }
    
    public mutating func fetchPost() {
        posts = []
        // TODO: FB fetch post data
    }
}
