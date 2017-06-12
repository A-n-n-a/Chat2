//
//  MessengerViewController.swift
//  Chat2
//
//  Created by Anna on 11.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import AVKit
import MobileCoreServices

class MessengerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //UICollectionViewDataSource, UICollectionViewDelegate {
    
    var chatTitle = ""
    
    var textMessagesArray = [String]()
    var messages = [JSQMessage]()
    let picker = UIImagePickerController()
    var sender = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title = interlocuter's name
        self.navigationItem.title = chatTitle
        
        picker.delegate = self as UIImagePickerControllerDelegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        self.sender = AuthProvider.Instance.userID()
        self.senderDisplayName = AuthProvider.Instance.userName
        MessagesHandler.Instance.delegate = self
        

        
    }
    
    
    func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return self.messages[indexPath.item]
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textMessagesArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell  //.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
//        // Use the outlet in our custom class to get a reference to the UILabel in the cell
//        cell.myLabel.text = self.items[indexPath.item]
//        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        //messages.append(JSQMessage(senderId: sender, displayName: sender, text: textMessagesArray[0]))
        //finishSendingMessage()
    }
    

}
