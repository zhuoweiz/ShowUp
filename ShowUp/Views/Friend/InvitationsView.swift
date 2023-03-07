//
//  InvitationsView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct InvitationRow: View {
    var pendingInvitation: PendingInvitation
    var refetch: () -> Void
    
    let db = Firestore.firestore();
    
    func accept() {
        // add userUID to joinedList of that habit, then delete invitation,
        db.collection("habits").document(pendingInvitation.habitID ?? "x").collection("guests").document(pendingInvitation.guestUID ?? "x").setData([
            "joined_date": Timestamp(date: Date()),
            "host_uid": pendingInvitation.hostUID!,
            "guest_uid": pendingInvitation.guestUID!,
            "habit_id": pendingInvitation.habitID!,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("DEBUG - InvitationRow accept(): Document successfully written!")
                
                // delete pending invitation
                delete()
            }
        }

    }
    
    func delete() {
        // simply delete this invitation
        db.collection("invitations").document(pendingInvitation.id!).delete() { err in
            if let err = err {
                print("DEBUG - InvitationRow: Error removing document: \(err)")
            } else {
                print("DEBUG - InvitationRow: Document successfully removed!")
                refetch()
            }
        }
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(pendingInvitation.habitTitle!)
                Text(pendingInvitation.hostUsername!)
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
            }
            Spacer()
            Button(action: delete) {
                Label("", systemImage: "xmark")
            }.buttonStyle(BorderlessButtonStyle())
            Button(action: accept) {
                Label("", systemImage: "checkmark")
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct InvitationsView: View {
    
    @State private var pendingInvitations: [PendingInvitation] = []
    
    let db = Firestore.firestore();
    
    func fetchInvitations() {
        // fetch invitations
        guard let user = Auth.auth().currentUser else {
            return;
        }
        
        var tmpArray: [PendingInvitation] = []
        db.collection("invitations").whereField("guest_uid", isEqualTo: user.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    // get habitID, get host_ids
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let newPendingInvitation = PendingInvitation(id: document.documentID, data: data)
                        tmpArray.append(newPendingInvitation);
                    }
                    
                    // get habitName, get hostName
                    pendingInvitations = tmpArray
                    for (index, pendinInvitation) in tmpArray.enumerated() {
                        
                        // get host username using hostUID
                        let hostRef = db.collection("profiles").document(pendinInvitation.hostUID!);
                        hostRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let userData = document.data()!
                                let username = userData["username"] as? String ?? "ANONYMOUS_"
                                pendingInvitations[index].hostUsername = username
                            } else {
                                print("Joined guest does not exist 2")
                            }
                        }
                        
                        // get habit title using habitID
                        let habitRef = db.collection("habits").document(pendinInvitation.habitID!);
                        habitRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let habitData = document.data()!
                                let title = habitData["title"] as? String ?? "DEFAULT_TITLE"
                                pendingInvitations[index].habitTitle = title
                            }
                        }
                    }
                    
                }
            }
    }
    
    
    var body: some View {
        List {
            ForEach(pendingInvitations) { pendingInvitation in
                InvitationRow(pendingInvitation: pendingInvitation, refetch: fetchInvitations)
            }
        }
        .navigationTitle("Pending Invites")
        .onAppear() {
            fetchInvitations()
        }
    }
}

struct InvitationsView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationsView()
    }
}
