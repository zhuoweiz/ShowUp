//
//  PreviousHabitsView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct PreviousHabitsView: View {
    var bio: String
    
    var body: some View {
        List {
            Section {
                Text(bio)
            } header: {
                Text("Enter your bio below.")
            }
        }.navigationTitle("Previous Habits")
    }
}

struct PreviousHabitsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousHabitsView(bio: "TEST INFO")
    }
}
