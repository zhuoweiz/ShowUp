//
//  PostImagePicker.swift
//  ShowUp
//
//  Created by Zhuowei Z on 5/6/22.
//

import Foundation
import SwiftUI

// what this does: get selected image pass back to parent view. no interaction with firebase.
struct PostImagePicker: UIViewControllerRepresentable {
    
  @Environment(\.presentationMode) private var presentationMode // allows you to dismiss the image picker overlay
  @Binding var selectedImage: UIImage // selected image binding
  @Binding var didSet: Bool // tells if the view was set or cancelled
  var sourceType = UIImagePickerController.SourceType.photoLibrary
    
  func makeUIViewController(context: UIViewControllerRepresentableContext<PostImagePicker>) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.navigationBar.tintColor = .clear
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator
    return imagePicker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController,
                              context: UIViewControllerRepresentableContext<PostImagePicker>) { }

  func makeCoordinator() -> Coordinator {
      Coordinator(self)
  }

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let control: PostImagePicker

    init(_ control: PostImagePicker) {
      self.control = control
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
          print("DEBUG: uploading image")
        
        // pass data

          self.control.selectedImage = image
          self.control.didSet = true
          self.control.presentationMode.wrappedValue.dismiss()
          
      }
    }
  }
}
