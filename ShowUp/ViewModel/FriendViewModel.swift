//
//  FriendViewModel.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/7/22.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
import UIKit

// TODO: MAKE SURE TO CLEAR DATA WHEN LOGGED OFF
class FriendVM : ObservableObject {
    @Published public var joinedHabits: [Habit] = []
    @Published public var postFeeds: [Post] = []
    
    let db = Firestore.firestore();
    
    public init() {
    }
    
    public func clean() {
        joinedHabits = []
        postFeeds = []
    }
    
    // get a list of data of users who invited me to their groups
    public func fetchInvitedFriend() {
        
    }
    
    public func fetchPostFeeds() {
        
    }
    
    public func fetchJoinedHabits() {
        guard let user = Auth.auth().currentUser else {
            return;
        }
        
        // get all gested habits
        var tmpHabitIDs: [String] = []
        var tmpHostUIDs: [String] = []
        db.collectionGroup("guests").whereField("guest_uid", isEqualTo: user.uid).getDocuments { (snapshot, error) in
            if let error = error {
                print("fetchJoinedHabits(): Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let tmpHabitID = data["habit_id"] as? String ?? "x"
                    let tmpHostUID = data["host_uid"] as? String ?? "UNKNOWNID_"
                    tmpHabitIDs.append(tmpHabitID);
                    tmpHostUIDs.append(tmpHostUID);
                }
                
                var tmpHabitArray: [Habit] = [];
                var callBackStepper = 0;
                for habitID in tmpHabitIDs {
                    self.db.collection("habits").document(habitID).getDocument { (document, err) in
                        if let document = document, document.exists {
//                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                            print("Document data: \(dataDescription)")
                            let data = document.data()!
                            let tmpHabit = Habit(id: document.documentID, data: data)
                            tmpHabitArray.append(tmpHabit)
                            callBackStepper += 1;
                            
                            if (callBackStepper == tmpHabitIDs.count) {
                                self.joinedHabits = tmpHabitArray
                            }
                        } else {
                            print("fetchJoinedHabits(): Document does not exist")
                        }
                    }
                }
            }
        }
    }
}
