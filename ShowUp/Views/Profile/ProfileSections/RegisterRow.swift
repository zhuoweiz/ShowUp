//
//  RegisterRow.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI

struct RegisterRow: View {
    @Binding var onRegister: Bool
    
    var body: some View {
        NavigationLink {
            RegisterView(onRegister: $onRegister)
        } label: {
            Label("Sign Up", systemImage: "person.badge.plus")
        }
        .padding()
    }
}

struct RegisterRow_Previews: PreviewProvider {
    static var previews: some View {
        RegisterRow(onRegister: .constant(false))
    }
}
