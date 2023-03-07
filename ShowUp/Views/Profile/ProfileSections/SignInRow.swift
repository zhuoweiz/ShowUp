//
//  SignInRow.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct SignInRow: View {
    var body: some View {
        NavigationLink {
            SignInView()
        } label: {
            Label("Sign In", systemImage: "person")
        }
        .padding()
    }
}

struct SignInRow_Previews: PreviewProvider {
    static var previews: some View {
        SignInRow()
    }
}
