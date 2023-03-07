//
//  ProfileView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var user_session: UserVM
    @EnvironmentObject var friendDataModel: FriendVM
    
    @State var isAuthenticated = false
    @State var onRegister = false
    
    @State private var isEditing: Bool = false
    @State private var isEditingAvatar: Bool = false

    
    @State private var isSet: Bool = false
    @State private var imageSelection: UIImage = UIImage(imageLiteralResourceName: "profile") // don't use for now
    @State private var showingPopover = false
    @State private var handle: AuthStateDidChangeListenerHandle?
    
    func signout() {
        user_session.signOut();
        friendDataModel.clean();
        isAuthenticated = false;
    }
    
    func onPickAvatar() {
        showingPopover.toggle()
    }
    
    var body: some View {
        NavigationView {
            List {
                if (isAuthenticated) {
                    Section {
                        ProfileImageRow(isSet: $isSet)
                        Button("Edit Avatar", action: onPickAvatar)
                            .popover(isPresented: $showingPopover) {
                                ImagePicker(selectedImage: $imageSelection, didSet: $isSet)
                            }
                    }
                    
                    Section {
                        UsernameRow()
                        BioRow()
                    } header: {
                        if (onRegister) {
                            Text("PLS FILL INFORMATION").foregroundColor(.red)
                        } else {
                            Text("Information")
                        }
                    }
                    
                    Section {
                        Text("\(user_session.email ?? "")")
                        Button(action: signout) {
                            Text("Sign Out")
                        }
                    } header: {
                        Text("Auth")
                    }
                    
                    DeveloperSection()
                } else {
                    SignInRow()
                    RegisterRow(onRegister: $onRegister)
                }
            }
            .navigationBarTitle("Profile")
            .onAppear() {
                handle = Auth.auth().addStateDidChangeListener { auth, user in
                    if let _ = user {
                        user_session.signIn();
                        isAuthenticated = true;
                    } else {
                        signout()
                    }
                }
            }
            .onDisappear() {
                Auth.auth().removeStateDidChangeListener(handle!)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
