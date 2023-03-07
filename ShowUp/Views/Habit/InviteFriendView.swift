//
//  InviteFriendView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct InviteFriendView: View {
    @State private var searchText: String = ""
    @State private var pendingInvites: [String] = [] // guest username
    @State private var accpetedInvite: [String] = [] // guest username
    
    @State private var showingAlert = false
    @State private var userNotFoundAlert = false
    @State private var successAlert = false
    @State private var invitationExistAlert = false
    
    var habitID: String
    
    let db = Firestore.firestore();
    
    func checkPrereqAndInvite() {
        var guestUID: String? = nil;
        
        // 1. check if invitation exists
        
        // 2. check if user exists
        db.collection("profiles").whereField("email", isEqualTo: searchText)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    userNotFoundAlert = true;
                } else {
                    for document in querySnapshot!.documents { // only one item
                        guestUID = document.documentID
                        break;
                    }
                    
                    // check if the user existed
                    guard let guestUID = guestUID else {
                        userNotFoundAlert = true;
                        return
                    }
                    db.collection("invitations")
                        .whereField("guest_uid", isEqualTo: guestUID)
                        .whereField("habit_id", isEqualTo: habitID)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                                userNotFoundAlert = true;
                            } else {
                                // check if invitation exists
                                if !(querySnapshot!.documents.isEmpty) {
                                    invitationExistAlert = true
                                } else {
                                    sendInvitation(guestUID: guestUID)
                                }
                            }
                        }
                }
            }
    }
    
    func sendInvitation(guestUID: String) {

        guard let user = Auth.auth().currentUser else {
            return;
        }
        var ref: DocumentReference? = nil
        ref = db.collection("invitations").addDocument(data: [
            "guest_uid": guestUID,
            "host_uid": user.uid,
            "habit_id": habitID,
        ]) { err in
            if let err = err {
                print("Error - InviteFriendView: adding document: \(err)")
            } else {
                print("DEBUG - InviteFriendView: Document added with ID: \(ref!.documentID)")
                successAlert = true;
                fetchPendingInvites();
            }
        }
    }
    
    func fetchJoinedUsers() {
        // check who is in the joined array under habit doc
        let docRef = db.collection("habits").document(habitID)
        
        docRef.collection("guests").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("fetchJoinedUsers(): Error getting documents: \(err)")
            } else {
                var joinedUsers: [String] = []
                
                for document in querySnapshot!.documents {
                    joinedUsers.append(document.documentID)
                }
                
                // get username for each joinedUser
                var tmpGuestArray: [String] = [] // will replace state
                for (_, guestUID) in joinedUsers.enumerated() {
                    let guestRef = db.collection("profiles").document(guestUID);
                    guestRef.getDocument { (guestDocument, error) in
                        if let guestDocument = guestDocument, guestDocument.exists {
                            let guestUserData = guestDocument.data()!
                            let guestUserName = guestUserData["username"] as? String ?? "ANONYMOUS_"
                            tmpGuestArray.append(guestUserName)
                            accpetedInvite = tmpGuestArray
                        } else {
                            print("Joined guest does not exist 2")
                        }
                    }
                }
            }
        }
        
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
////                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
////                print("DEBUG - InvitedFriendView fetchJoinedUsers(): Document data: \(dataDescription)")
//                let data = document.data()!
//                let joinedUsers = data["joined_guests"] as? [String] ?? []
//
//                // get username for each joinedUser
//                var tmpGuestArray: [String] = [] // will replace state
//                for (_, guestUID) in joinedUsers.enumerated() {
//                    let guestRef = db.collection("profiles").document(guestUID);
//                    guestRef.getDocument { (guestDocument, error) in
//                        if let guestDocument = guestDocument, guestDocument.exists {
//                            let guestUserData = guestDocument.data()!
//                            let guestUserName = guestUserData["username"] as? String ?? "ANONYMOUS_"
//                            tmpGuestArray.append(guestUserName)
//                            accpetedInvite = tmpGuestArray
//                        } else {
//                            print("Joined guest does not exist 2")
//                        }
//                    }
//                }
//
//            } else {
//                print("DEBUG - InviteFriendView fetchJoinedUsers(): Document does not exist")
//            }
//        }
    }
    
    func fetchPendingInvites() {
        // look into invitation collection, check matching habit_id and host_uid
        guard let user = Auth.auth().currentUser else {
            return;
        }
        db.collection("invitations")
            .whereField("habit_id", isEqualTo: habitID)
            .whereField("host_uid", isEqualTo: user.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    userNotFoundAlert = true;
                } else {
                    var tmpPendingInviteGuestIDs : [String] = []
                    for document in querySnapshot!.documents {
                        let invitationData = document.data()
                        let tmpGuestID = invitationData["guest_uid"] as? String ?? ""
                        if (!tmpGuestID.isEmpty) {
                            tmpPendingInviteGuestIDs.append(tmpGuestID)
                        }
                    }
                    
                    for guestUID in tmpPendingInviteGuestIDs {
                        db.collection("profiles").document(guestUID).getDocument { (document, err) in
                            if let document = document, document.exists {
//                                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                                print("Document data: \(dataDescription)")
                                let data = document.data()!
                                let guestUsername = data["username"] as? String ?? "ANONYMOUS_"
                                pendingInvites.append(guestUsername)
                                
                            } else {
                                print("ERROR: InviteFriendView fetchPendingInvites(): Document does not exist")
                            }
                        }
                    }
                }
            }
    }
    
    var body: some View {
        List {
            Section {
                if (accpetedInvite.isEmpty) {
                    Text("NONE")
                } else {
                    ForEach(accpetedInvite, id: \.self) { item in
                        HStack {
                            Text("Username")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(item)
                        }
                    }
                }
            } header: {
                Text("Friends Joined")
            }
            
            Section {
                TextField("Enter Here...", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    
                Button("Send") {
                    // TODO: send invitation logic.
                    if searchText.count > 5 {
                        checkPrereqAndInvite() // and send invitation
                    } else {
                        showingAlert = true
                    }
                }.alert("Not valid email", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }.alert("User not found", isPresented: $userNotFoundAlert) {
                    Button("OK", role: .cancel) { }
                }.alert("Success", isPresented: $successAlert) {
                    Button("OK", role: .cancel) {
                        searchText = ""
                    }
                }.alert("Invitation Exits!", isPresented: $invitationExistAlert) { }
            } header: {
                Text("Invite Friend by Email")
            }
            
            Section {
                if (pendingInvites.isEmpty) {
                    Text("NONE")
                } else {
                    ForEach(pendingInvites, id: \.self) { item in
                        Text(item)
                    }
                }
            } header: {
                Text("Pneding Invites")
            }
        }
        .onAppear() {
            fetchJoinedUsers()
            fetchPendingInvites()
        }
        .navigationTitle("Friends Invited")
        .toolbar {
        }
    }
}

struct InviteFriendView_Previews: PreviewProvider {
    static var previews: some View {
//        InviteFriendView()
        EmptyView()
    }
}
