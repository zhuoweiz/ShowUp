//
//  HabitView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct HabitView: View {
    @EnvironmentObject var user_session: UserVM
    @EnvironmentObject var friendDataModel: FriendVM
    
    @State private var handle: AuthStateDidChangeListenerHandle?
    
    var job = [1, 2, 3, 4]
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                if user_session.userHabits.isEmpty {
                    Text("No Habits Yet")
                }
                LazyVGrid(columns: columns, alignment: .center, spacing: 24) {
                    ForEach(user_session.userHabits) { habit in
                        HabitBlock(habit: habit)
                    }
                }
                .padding(.top, 20)
            }
            .navigationBarTitle("Habits")
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        AddHabitView()
                    } label: {
                        Text("Add Habit")
                    }
                }
            }
            .onAppear() {
                handle = Auth.auth().addStateDidChangeListener { auth, user in
                    if let _ = user {
                        user_session.fetchUserHabits();
                    } else {
                        user_session.signOut();
                        friendDataModel.clean();
                    }
                }
            }
            .onDisappear() {
                Auth.auth().removeStateDidChangeListener(handle!)
            }
        }
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        HabitView()
    }
}
