//
//  FriendView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct FriendView: View {
    @State private var friendSegment = 0
    @EnvironmentObject var user_session: UserVM
    @EnvironmentObject var friendDataModel: FriendVM
    
    @State private var handle: AuthStateDidChangeListenerHandle?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    Picker("Pick", selection: $friendSegment) {
                        Text("Habits").tag(0)
//                        Text("Friends").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if (friendSegment == 0) {
                        FriendHabitView(friendDataModel: friendDataModel)
                    } else {
                        FriendPostView()
                    }
                }
            }
            .navigationBarTitle("Friends")
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        InvitationsView()
                    } label: {
                        Text("Invitations")
                    }
                }
            }
            .onAppear() {
                handle = Auth.auth().addStateDidChangeListener { auth, user in
                    if let _ = user {
                        friendDataModel.fetchJoinedHabits();
                        friendDataModel.fetchPostFeeds();
                    } else {
                        friendDataModel.clean();
                        user_session.signOut();
                    }
                }
            }
            .onDisappear() {
                Auth.auth().removeStateDidChangeListener(handle!)
            }
        }
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
//        FriendView()
        EmptyView()
    }
}
