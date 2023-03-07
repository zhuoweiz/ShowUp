//
//  MainView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HabitView()
            .tabItem { //note how this is modifying `NavigationView`
                Image(systemName: "note.text")
                Text("Habit")
            }
            
            FriendView()
            .tabItem { //note how this is modifying `NavigationView`
                Image(systemName: "person.3.fill")
                Text("Friend")
            }
            
            ProfileView()
            .tabItem { //note how this is modifying `NavigationView`
                Image(systemName: "person.crop.circle")
                Text("Profile")
            }
        }.onAppear {
            UITableView.appearance().keyboardDismissMode = .onDrag
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
