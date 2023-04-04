//
//  UploadViewController.swift
//  Instagramclone
//
//  Created by Can Kanbur on 4.04.2023.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var uploadButton: UIButton!
    @IBOutlet var commentText: UITextField!
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(
            chooseImage))

        imageView.addGestureRecognizer(gestureRecognizer)
    }

    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }

    @IBAction func actionButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()

        let mediaFolder = storageReference.child("media")

        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString

            let imageReference = mediaFolder.child("\(uuid).jpg")

            imageReference.putData(data, metadata: nil) { _, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference: DocumentReference?
                            print("\(firestoreReference)")
                            let firestorePost = ["imageUrl": imageUrl!, "postedBy": Auth.auth().currentUser!.email!, "postComment": self.commentText.text!, "date": FieldValue.serverTimestamp(), "likes": 0] as [String : Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                                }else{
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    
                                    self.tabBarController?.selectedIndex = 0
                                }

                            })
                        }
                    }
                }
            }
        }
    }

    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
