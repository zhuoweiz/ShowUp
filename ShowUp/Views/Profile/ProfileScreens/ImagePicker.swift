//
//  ImagePicker.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseAuth

struct ImagePicker: UIViewControllerRepresentable {
    @EnvironmentObject var user_session: UserVM
  @Environment(\.presentationMode) private var presentationMode // allows you to dismiss the image picker overlay
  @Binding var selectedImage: UIImage // selected image binding
  @Binding var didSet: Bool // tells if the view was set or cancelled
  var sourceType = UIImagePickerController.SourceType.photoLibrary
    
  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.navigationBar.tintColor = .clear
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator
    return imagePicker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController,
                              context: UIViewControllerRepresentableContext<ImagePicker>) { }

  func makeCoordinator() -> Coordinator {
      Coordinator(self)
  }

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let control: ImagePicker

    init(_ control: ImagePicker) {
      self.control = control
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
        print("DEBUG: uploading image")
        
        // upload image to fb storage
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            print("ERROR: error doing image data translation")
            return }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        
        if let user = Auth.auth().currentUser {
            let profileRef = storageRef.child("profile/\(user.uid).png")
            
            let _ = profileRef.putData(imageData, metadata: nil) { (metadata, error) in
                print("DEBUG: upload result: \(String(describing: error))")
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                _ = metadata.size
                // You can also access to download URL after upload.
                profileRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                    self.control.selectedImage = UIImage(data: imageData) ?? image
                    self.control.user_session.profileImg = UIImage(data: imageData) ?? image
                    self.control.didSet = true
                    
                    print("DEBUG: SUCCESS! image url is: \(downloadURL)")
                    self.control.presentationMode.wrappedValue.dismiss()
                }
            }
        } else {
            print("ERROR: user not authenticated for profile upload")
        }
      }
    }
  }
}
