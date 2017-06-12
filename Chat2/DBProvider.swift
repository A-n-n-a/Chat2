//
//  DBProvider.swift
//  Chat App For iOS 10
//
//  Created by MacBook on 11/22/16.
//  Copyright © 2016 Awesome Tuts. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol FetchData: class {
    func dataReceived(contacts: [Contact]);
}

class DBProvider {

    private static let _instance = DBProvider();
    
    weak var delegate: FetchData?;
    
    private init() {}
    
    static var Instance: DBProvider {
        return _instance;
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference();
    }
    
    var contactsRef: FIRDatabaseReference {
        return dbRef.child(Constants.CONTACTS);
    }
    
    var messagesRef: FIRDatabaseReference {
        return dbRef.child(Constants.MESSAGES);
    }
    
    var mediaMessagesRef: FIRDatabaseReference {
        return dbRef.child(Constants.MEDIA_MESSAGES);
    }
    
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://ubertesterapp.appspot.com");
    }
    
    var imageStorageRef: FIRStorageReference {
        return storageRef.child(Constants.IMAGE_STORAGE);
    }
    
    var videoStorageRef: FIRStorageReference {
        return storageRef.child(Constants.VIDEO_STORAGE);
    }
    
    func saveUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password];
        
        contactsRef.child(withID).setValue(data);
    }
    
    func getContacts() {
        
        contactsRef.observeSingleEvent(of: FIRDataEventType.value) {
            (snapshot: FIRDataSnapshot) in
            var contacts = [Contact]();
            
            if let myContacts = snapshot.value as? NSDictionary {
                
                for (key, value) in myContacts {
                 
                    if let contactData = value as? NSDictionary {
                    
                        if let email = contactData[Constants.EMAIL] as? String {
                            
                            let id = key as! String;
                            let newContact = Contact(id: id, name: email);
                            contacts.append(newContact);
                        }
                    }
                }
            }
            self.delegate?.dataReceived(contacts: contacts);
        }

    }
    
} // class
















































