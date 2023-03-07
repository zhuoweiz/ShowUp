//
//  EditView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct EditView: View {
    var key: String
    @State var value: String
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            TextField("Enter \(key) here", text: $value)
        }
        .toolbar {
            ToolbarItem {
                Button("Confirm") {
                    let db = Firestore.firestore()
                    
                    guard let user = Auth.auth().currentUser else {
                        print("ERROR: add username - bad auth")
                        return;
                    }
                    
                    let userRef = db.collection("profiles").document("\(user.uid)")
                    userRef.updateData([
                        key: value
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
