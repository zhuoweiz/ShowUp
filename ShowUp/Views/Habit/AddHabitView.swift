//
//  AddHabitView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct AddHabitView: View {
    @State private var title: String = ""
    @State private var frequency: Int = 1
    @State private var desc: String = ""
    @State private var duration: Int = 2
    @State private var startDate = Date()
    
    @Environment(\.dismiss) var dismiss
    
    let frequencyChoices = ["Daily", "Weekly"]
    
    var body: some View {
        Form {
            Section {
                TextField("Enter Here", text: $title)
            } header: {
                Text("Basic Fnfo")
            }
            
            Section {
                TextEditor(text: $desc)
                    .lineLimit(10)
            } header: {
                Text("Description")
            }
            
            Section {
                Picker("Choose your start date", selection: $frequency) {
                    ForEach(0 ..< 2, id: \.self) { index in
                        Text("\(frequencyChoices[index])")
                    }
                }
                .pickerStyle(.segmented)
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
            } header: {
                Text("Frequency")
            }
            
            Section {
                DatePicker("StartDate",
                           selection: $startDate,
                           in: Date.now...,
                           displayedComponents: [.date])
                
                if frequency == 0 {
                    Picker("Duration", selection: $duration) {
                        ForEach(7 ..< 22) {
                            Text("\($0) Days")
                        }
                    }
                } else {
                    Picker("Duration", selection: $duration) {
                        ForEach(2 ..< 13) {
                            Text("\($0) Weeks")
                        }
                    }
                }
            } header: {
                Text("Time")
            }
            
            Button("Save") {
               // FB: add habit
                print("DEBUG - AddHabitView: Creating new habit.")
                
                // FB: trigger FB create new habit. then dismiss
                guard let user = Auth.auth().currentUser else {
                    print("ERROR - AddHabitView confirm(): user not authenticated")
                    return;
                }
                let db = Firestore.firestore()
                let docData: [String: Any] = [
                    "title" : title,
                    "desc" : desc,
                    "frequency" : frequency,
                    "duration" : duration,
                    "start_date" : Timestamp(date: startDate),
                    "author" : db.collection("profiles").document(user.uid),
                ]
                var ref: DocumentReference? = nil
                ref = db.collection("habits").addDocument(data: docData) { err in
                    if let err = err {
                        print("DEBUG - AddHabitView: Error adding document: \(err)")
                    } else {
                        print("DEBUG - AddHabitView: Document added with ID: \(ref!.documentID)")
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Add Habit")
        .toolbar {
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
    }
}
