//
//  DatabaseService.swift
//  swiftui-chat
//
//  Created by Chris Ching on 2021-12-09.
//

import Foundation
import Contacts
import Firebase
import UIKit

class DatabaseService {
    
    func getPlatformUsers(localContacts: [CNContact], completion: @escaping ([User]) -> Void) {
        
        // The array where we're storing fetched platform users
        var platformUsers = [User]()
        
        // Construct an array of string phone numbers to look up
        var lookupPhoneNumbers = localContacts.map { contact in
            
            // Turn the contact into a phone number as a string
            return TextHelper.sanitizePhoneNumber(contact.phoneNumbers.first?.value.stringValue ?? "")
        }
        
        // Make sure that there are lookup numbers
        guard lookupPhoneNumbers.count > 0 else {
            
            // Callback
            completion(platformUsers)
            return
        }
        
        // Query the database for these phone numbers
        let db = Firestore.firestore()
        
        // Perform queries while we still have phone numbers to look up
        while !lookupPhoneNumbers.isEmpty {
        
            // Get the first < 10 phone numbers to look up
            let tenPhoneNumbers = Array(lookupPhoneNumbers.prefix(10))
            
            // Remove the < 10 that we're looking up
            lookupPhoneNumbers = Array(lookupPhoneNumbers.dropFirst(10))
            
            // Look up the first 10
            let query = db.collection("users").whereField("phone", in: tenPhoneNumbers)
        
            // Retrieve the users that are on the platform
            query.getDocuments { snapshot, error in
                
                // Check for errors
                if error == nil && snapshot != nil {
                    
                    // For each doc that was fetched, create a user
                    for doc in snapshot!.documents {
                        
                        if let user = try? doc.data(as: User.self) {
                            
                            // Append to the platform users array
                            platformUsers.append(user)
                        }
                    }
                    
                    // Check if we have anymore phone numbers to look up
                    // If not, we can call the completion block and we're done
                    if lookupPhoneNumbers.isEmpty {
                        // Return these users
                        completion(platformUsers)
                    }
                }
            }
        }
        
        
        
    }
    
    func setUserProfile(firstName: String, lastName: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
        // TODO: Guard against logged out users
        
        // Get a reference to Firestore
        let db = Firestore.firestore()
        
        // Set the profile data
        // TODO: After implementing authentication, instead create a document with the actual user's id
        let doc = db.collection("users").document()
        doc.setData(["firstname": firstName,
                     "lastname": lastName])
        
        // Check if an image is passed through
        if let image = image {
        
            // Create storage reference
            let storageRef = Storage.storage().reference()
            
            // Turn our image into data
            let imageData = image.jpegData(compressionQuality: 0.8)
            
            // Check that we were able to convert it to data
            guard imageData != nil else {
                return
            }
            
            // Specify the file path and name
            let path = "images/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { meta, error in
                
                if error == nil && meta != nil
                {
                    // Set that image path to the profile
                    doc.setData(["photo": path], merge: true) { error in
                        if error == nil {
                            // Success, notify caller
                            completion(true)
                        }
                    }
                }
                else {
                    
                    // Upload wasn't successful, notify caller
                    completion(false)
                }
            }
            
            
        }
        
    }
    
}
