//
//  UserModel.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
import UIKit

class UserVM : ObservableObject {
    
    @Published public var isAuthenticated: Bool = false
    @Published public var isProfileFetched: Bool = false // if the profile image is fetched, save some data, reuse profileImg.
    
    @Published public var username: String?
    @Published public var bio: String?
    @Published public var email: String?
    @Published public var profileImg : UIImage?
    
    @Published public var userHabits: [Habit] = []
    @Published public var friendHabits: [Habit] = []
    
    @Published public var handle: AuthStateDidChangeListenerHandle?

    public init() {
        
    }
    
    // called once when login action is confirmed, fetch basic user profile info
    public func signIn() {
        print("DEBUG - UserVM signIn()")
        
        guard let user = Auth.auth().currentUser else {
            print("ERROR - UserVM signIn(): user not authed, should not call this func")
            return;
        }
        isAuthenticated = true;
        email = user.email
        let uid = user.uid;

        // FB: profileImage & username update
        if (!isProfileFetched) {
            let storage = Storage.storage()
            let pathReference = storage.reference(withPath: "profile/\(uid).png")
            pathReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("Download error \(error)")
                } else {
                    // Data is returned
                    print("DEBUG: profile picture data fetched")
                    self.isProfileFetched = true;
                    self.profileImg = UIImage(data: data!);
                }
            }
        }
        
        // FB: should also fill all other data such as habit and stuff
        let db = Firestore.firestore()
        let docRef = db.collection("profiles").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                if let fb_username = document.data()!["username"] {
                    self.username = fb_username as? String
                }
                if let fb_bio = document.data()!["bio"] {
                    self.bio = fb_bio as? String
                }
            } else {
                print("ERROR - UserVM signIn(): Document does not exist")
            }
        }
    }
    
    // called on home screen
    public func autoSignIn() {
        
    }
    
    public func fetchUserHabits() {
        guard let user = Auth.auth().currentUser else {
            print("ERROR - UserVM fetchUserHabits(): user not authed, should not call this func")
            return;
        }
        let uid = user.uid;

        var tmpHabitArray: [Habit] = []
        let db = Firestore.firestore()
        let habitRef = db.collection("habits")
        habitRef.whereField("author", isEqualTo: db.collection("profiles").document(uid))
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            let id = document.documentID
                            let data = document.data()
                            
                            let newHabit = Habit(id: id, data: data);
                            tmpHabitArray.append(newHabit)
                        }
                        
                        self.userHabits = tmpHabitArray
                    }
            }
    }
    
    public func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            isAuthenticated = false;
            isProfileFetched = false;
            profileImg = nil;
            username = nil;
            bio = nil;
            email = nil;
            
            userHabits = [];
            friendHabits = [];
        } catch let signOutError as NSError {
          print("DEBUG - UserVM signOut(): Error signing out: %@", signOutError)
        }
    }
    
    
    public func listen(completed: @escaping () -> (), noauth: @escaping() -> ()) {
        print("DEBUG - UserVM: listner attached")
        handle = Auth.auth().addStateDidChangeListener { auth, user in
                if let newuser = user {
                        print("Got user: \(newuser.email ?? "DEFAULT_EMAIL")")
                        self.isAuthenticated = true;
                        self.email = user?.email ?? "undefined"
                        completed();
                } else {
                        self.isAuthenticated = false;
                        noauth();
                }
        }
    }
    
    public func unlisten() {
        print("DEBUG - UserVM: listner dettached")
        Auth.auth().removeStateDidChangeListener(handle!)
    }
}

