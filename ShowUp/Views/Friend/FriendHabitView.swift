//
//  FriendGroupView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct FriendHabitView: View {
    @ObservedObject var friendDataModel: FriendVM;
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            if friendDataModel.joinedHabits.isEmpty {
                Text("No joined habits yet, ask your friend to invite you~")
                    .foregroundColor(.secondary)
            }
            LazyVGrid(columns: columns, alignment: .center, spacing: 24) {
                ForEach(friendDataModel.joinedHabits) { habit in
                    FriendHabitBlock(habit: habit)
                }
            }
            .padding(.top)
        }
    }
}

struct FriendGroupView_Previews: PreviewProvider {
    static var previews: some View {
//        FriendGroupView()
        EmptyView()
    }
}
