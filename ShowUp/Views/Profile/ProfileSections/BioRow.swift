//
//  PreviousHabitsRow.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct BioRow: View {
    
    @EnvironmentObject var user_session: UserVM
    
    var body: some View {
        NavigationLink {
            EditView(key: "bio", value: user_session.bio ?? "")
        } label: {
            HStack {
                Text("Bio")
                Spacer()
                Text(user_session.bio ?? "")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct PreviousHabitsRow_Previews: PreviewProvider {
    static var previews: some View {
        BioRow()
    }
}
