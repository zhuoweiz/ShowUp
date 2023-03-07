//
//  PendingInvitation.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/7/22.
//

import Foundation



struct PendingInvitation: Identifiable {
    let id: String?
    
    let hostUID: String?
    let habitID: String?
    let guestUID: String?
    
    var hostUsername: String? = ""
    var guestUsername: String? = ""
    var habitTitle: String? = ""
    
    init() {
        id = ""
        hostUID = ""
        habitID = ""
        guestUID = ""
    }
    
    init(id: String, data: [String: Any]) {
        //
        self.id = id;
        
        hostUID = data["host_uid"] as? String ?? ""
        guestUID = data["guest_uid"] as? String ?? ""
        habitID = data["habit_id"] as? String ?? ""
    }
}
