//
//  SignInView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @EnvironmentObject var user_session: UserVM
    
    @State var email = "zhuoweiz10@gmail.com"
    @State var password = "123123123"
    
    @Environment(\.dismiss) var dismiss
    
    func signin() {
        print("DEBUG - SignInView signin()")
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("DEBUG: sign in success")
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $password)
            
            Button(action: signin) {
                Label("Sign In", systemImage: "circle")
            }
        }
        .navigationTitle("Sign In")
        .padding()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
