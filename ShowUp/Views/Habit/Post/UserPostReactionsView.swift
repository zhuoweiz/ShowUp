//
//  UserPostReactionsView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct ReactionRow: View {
    var reaction: Reaction
    @State private var dateText: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dateText)
                    .foregroundColor(.secondary)
                    .font(.system(size: 13))
                Text(reaction.title ?? "default_reaction_")
                    .padding(.top, 4)
            }
            Spacer()
        }.onAppear() {
            let date = reaction.creationDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            dateText = dateFormatter.string(from: date ?? Date())
        }
    }
}

struct UserPostReactionsView: View {
    @EnvironmentObject var user_session: UserVM
    
    var postID: String
    var habitID: String
    
    @State private var reactions: [Reaction] = []
    let db = Firestore.firestore();
    
    var body: some View {

        List {
            if (reactions.isEmpty) {
                Text("No Reactions Yet.")
                    .foregroundColor(.secondary)
            }
            ForEach(reactions) { reaction in
                ReactionRow(reaction: reaction)
            }
            
        }.onAppear() {
            // FB: fetch all reactions
            db.collection("habits").document(habitID).collection("posts").document(postID).collection("reactions").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var tmpArray: [Reaction] = []
                    for document in querySnapshot!.documents {
//                                    print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        let newReaction = Reaction(id: document.documentID, data: data)
                        tmpArray.append(newReaction)
                    }
                    reactions = tmpArray
                }
            }
        }
    }
}

struct UserPostReactionsView_Previews: PreviewProvider {
    static var previews: some View {
//        UserPostReactionsView()
        EmptyView()
    }
}
