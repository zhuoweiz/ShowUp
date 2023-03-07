//
//  RegisterView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @State var email = "zhuoweiz10@gmail.com"
    @State var password = "123123123"
    @Binding var onRegister: Bool
    
    @Environment(\.dismiss) var dismiss
    
    func signup() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("DEBUG: register success")
                onRegister = true
                
                // create a profile document in database right after successful registration.
                let db = Firestore.firestore()
                let docData: [String: Any] = [
                    "username" : email.split(separator: "@")[0],
                    "email" : email,
                ]
                db.collection("profiles").document("\(authResult?.user.uid ?? email)").setData(docData)
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
            
            Button(action: signup) {
                Label("Sign Up", systemImage: "circle")
            }
        }
        .navigationTitle("Sign Up")
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(onRegister: .constant(true))
    }
}
