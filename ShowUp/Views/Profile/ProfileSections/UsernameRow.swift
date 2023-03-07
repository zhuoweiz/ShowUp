//
//  UsernameRow.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct UsernameRow: View {
    @EnvironmentObject var user_session: UserVM
    
    var body: some View {
        NavigationLink {
            EditView(key: "username", value: user_session.username ?? "")
        } label: {
            HStack {
                Text("Username")
                Spacer()
                Text(user_session.username ?? "")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct UsernameRow_Previews: PreviewProvider {
    static var previews: some View {
        UsernameRow()
    }
}
