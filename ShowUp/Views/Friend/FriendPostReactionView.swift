//
//  FriendPostReactionView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/7/22.
//

import SwiftUI
import Firebase
import NaturalLanguage
import CoreML

struct FriendPostReactionRow: View {
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

struct FriendPostReactionView: View {
    @EnvironmentObject var user_session: UserVM
    
    var postID: String
    var habitID: String
    @State private var segmentPicked = 0
    @State private var newText = ""
    @State private var textStatus = 0 // 0: empty text, 1: entered negative, 2: entered positive, 3: extremely bad, 4: very positive
 
    @State private var reactAlert = false;
    @State private var successAlert = false;
    @State private var sentimentAlert = false;
    
    @State private var reactions: [Reaction] = []
    
    @FocusState private var nameIsFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
    let minTextCount = 18;
    let maxTextCount = 140;
    let db = Firestore.firestore();

    var body: some View {
        List {
            Picker("Pick", selection: $segmentPicked) {
                Text("Existing").tag(0)
                Text("Create New").tag(1)
            }
            .pickerStyle(.segmented)
            .listRowInsets(.init())
            .listRowBackground(Color.clear)
            
            if (segmentPicked == 0) {
                if (reactions.isEmpty) {
                    Text("No Reactions Yet.")
                        .foregroundColor(.secondary)
                }
                Section {
                    ForEach(reactions) { reaction in
                        FriendPostReactionRow(reaction: reaction)
                    }
                } header: {
                    Text("Reactions")
                }.onAppear() {
                    fetchReactions()
                }
            } else {
                Section {
                    Text(checkStatusText())
                        .foregroundColor(checkStatus())
                    TextEditor(text: $newText)
                        .focused($nameIsFocused)
                        .onChange(of: newText) { newValue in
                            if newValue.count < minTextCount {
                                textStatus = 0;
                                return;
                            }
                            checkSentiment(newValue: newValue)
                        }
                        .onChange(of: nameIsFocused) { newValue in
                            
                        }
                    Button("React") {
                        sendReaction()
                    }.alert("Reaction must be at least \(minTextCount) characters and no more than \(maxTextCount) characters.", isPresented: $reactAlert) {
                        Button("OK", role: .cancel) { }
                    }.alert("Success.", isPresented: $successAlert) {
                        Button("OK", role: .cancel) {
                            newText = ""
                        }
                    }.alert("Harassment is not allowed.", isPresented: $sentimentAlert) {
                        Button("OK", role: .cancel) {}
                    }
                } header: {
                    Text("Write New Reaction")
                }
            }
        
        }
        .navigationTitle("Reactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension FriendPostReactionView {
    func checkSentiment(newValue: String) {
        if newValue.count < minTextCount {
            textStatus = 0;
            return;
        }
        do {
            let mlModel = try sentiment140(configuration: MLModelConfiguration()).model
            let sentimentPredictor = try NLModel(mlModel: mlModel)
            let detailedResult = sentimentPredictor.predictedLabelHypotheses(for: newValue, maximumCount: 2)
            print(detailedResult)
            
            let negativeLevel = detailedResult["0"] ?? 0.5
            if (negativeLevel <= 0.3) {
                textStatus = 4
            } else if (negativeLevel < 0.49) {
                textStatus = 2
            } else if (negativeLevel < 0.65) {
                textStatus = 1
            } else {
                textStatus = 3
            }
        } catch let modelError as NSError {
            print("DEBUG - FriendPostReactionView React(): Error signing out: %@", modelError)
        }
    }

    func checkStatus() -> Color {
        if (textStatus == 2) {
            return Color.primary
        } else if (textStatus == 3) {
            return Color.orange
        } else if (textStatus == 4) {
            return Color.blue
        } else {
            return Color.secondary
        }
    }
    
    func checkStatusText() -> String {
        if (textStatus == 3) {
            return "Try Something Positive"
        } else if (textStatus == 2) {
            return "Looks Good!"
        } else if (textStatus == 4) {
            return "Thank you for the nice words!"
        }
        return "Enter A Short Text Below"
    }
    
    private func fetchReactions() {
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
    
    func sendReaction() {
        if (newText.count >= minTextCount && newText.count <= maxTextCount) {
            // check sentiment analysis:
            
            if (textStatus == 3) {
                sentimentAlert = true;
                return;
            }
            
            // FB: trigger fb save new reaction
            guard let user = Auth.auth().currentUser else {
                return;
            }
            db.collection("habits").document(habitID).collection("posts").document(postID).collection("reactions").document(user.uid).setData([
                "guest_uid": user.uid,
                "post_id": postID,
                "habit_id": habitID,
                "creation_date": Timestamp(date: Date()),
                "title": newText,
                "author": user_session.username ?? "",
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    successAlert = true
                }
            }

        } else {
            reactAlert = true
        }
    }
}

struct FriendPostReactionView_Previews: PreviewProvider {
    static var previews: some View {
//        FriendPostReactionView()
        EmptyView()
    }
}
