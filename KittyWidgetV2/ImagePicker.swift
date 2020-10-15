//
//  ImagePicker.swift
//  KittyWidget
//
//  Created by SORA on 2020/9/25.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{

    @EnvironmentObject var myData: MyData
    @Binding var basicData : BasicData
    @Environment(\.presentationMode) var sheet
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
     
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = sourceType
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
     
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
            
        }
    
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
        var parent: ImagePicker
     
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
     
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.basicData.background = image
                let ind = parent.myData.dataStream.firstIndex(where: {parent.basicData.id == $0.id})!
                parent.myData.dataStream[ind].background = image
                DispatchQueue.global(qos: .default).async {
                    self.parent.myData.storedData[ind].background = image.pngData()!
                    UserDefaults.standard.set(self.parent.myData.jsonData, forKey: UserDataKeys.storedData)
                }
            }
            parent.sheet.wrappedValue.dismiss()
        }
    }
    
}
