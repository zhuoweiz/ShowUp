//
//  ShowUpApp.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

@main
struct ShowUpApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var user_session = UserVM()
    @StateObject private var friendDataModel = FriendVM()
    
    init() {
        FirebaseApp.configure()
        
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(user_session)
                .environmentObject(friendDataModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
