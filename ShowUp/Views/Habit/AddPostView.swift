//
//  AddPostView.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct AddPostView: View {
    @Environment(\.dismiss) var dismiss
    
    var habitId: String?
    @Binding var fetchFlag: Bool
    
    @State var title: String = ""
    @State var photoPicked: UIImage = UIImage(imageLiteralResourceName: "profile")
    @State var didImageSet: Bool = false
    
    @State var lock: Bool = false
    
    @State private var showingPopover: Bool = false
    
    func onPickImage() {
        showingPopover.toggle()
    }
    
    var body: some View {
        Form {
            Section {
                TextEditor(text: $title)
                    .lineLimit(10)
            } header: {
                Text("Description")
            }
            
            Section {
                Button("Select Image", action: onPickImage)
                    .popover(isPresented: $showingPopover) {
                        PostImagePicker(selectedImage: $photoPicked, didSet: $didImageSet)
                    }
                if (didImageSet) {
                    Image(uiImage: photoPicked)
                        .resizable()
                        .scaledToFit()
                }
            } header: {
                Text("Upload Photo")
            }
            
            
            Button("Save") {
               // FB: add habit
                print("DEBUG - AddPostView: Creating new post.")
                guard let _ = habitId else {
                    return;
                }
                
                // FB: trigger FB create new habit. then dismiss
                // TODO: check correctness
                guard let user = Auth.auth().currentUser else {
                    print("ERROR - AddPostView confirm(): user not authenticated")
                    return;
                }
                
                let db = Firestore.firestore()
                let docData: [String: Any] = [
                    "title" : title,
                    "habit_id" : habitId,
                    "post_date" : Timestamp(date: Date()),
                ]
                var ref: DocumentReference? = nil
                lock = true
                ref = db.collection("habits").document(habitId!).collection("posts").addDocument(data: docData) { err in
                    
                    
                    if let err = err {
                        print("DEBUG - AddPostView: Error adding document: \(err)")
                        lock = false;
                    } else {
                        print("DEBUG - AddPostView: Document added with ID: \(ref!.documentID)")
                        // TODO: FB: upload image using the postID as a reference.
                        
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let postRef = storageRef.child("post/\(ref!.documentID).png")
                        
                        guard let imageData = photoPicked.jpegData(compressionQuality: 0.5) else {
                            print("ERROR: error doing image data translation")
                            return
                        }
                        
                        let _ = postRef.putData(imageData, metadata: nil) { (metadata, error) in
                            print("DEBUG - AddPostView: upload result: \(String(describing: error))")
                            guard let metadata = metadata else {
                                // Uh-oh, an error occurred!
                                lock = false;
                                return
                            }
                            postRef.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                    // Uh-oh, an error occurred!
                                    lock = false;
                                    return
                                }
                                
                                print("DEBUG - AddPostView: SUCCESS! image url is: \(downloadURL)")
                                // End of sequence processing
                                lock = false;
                                fetchFlag = false;
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Add Post")
        .disabled(lock)
        .navigationBarBackButtonHidden(lock)
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
//        AddPostView()
        EmptyView()
    }
}
