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
import Firebase

class MessengerViewController: JSQMessagesViewController { //UIImagePickerControllerDelegate, UINavigationControllerDelegate { //UICollectionViewDataSource, UICollectionViewDelegate {
    
    var channelRef: DatabaseReference?
    var channel: Channel? //{
//        didSet {
//            title = channel?.userName
//        }
//    }
    var chatTitle = ""
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var textMessagesArray = [String]()
    var messages = [JSQMessage]()
    let picker = UIImagePickerController()
    var sender = String()
    var avatarImage = UIImage()
    var dateArray = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = chatTitle
        print(self.senderId)
        self.senderDisplayName = chatTitle
        print(self.senderDisplayName)
        
        // title = interlocuter's name
        self.navigationItem.title = chatTitle
        
        //print("Text number: \(textMessagesArray.count)")
        for i in textMessagesArray {
            var n = 0
            let singleMessage = JSQMessage(senderId: senderId, senderDisplayName: senderId, date: dateArray[n], text: i)
            messages.append(singleMessage!)
            n += 1
            print("Message count = \(messages.count)")
        }

        //messages.append(JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: dateArray[0], text: textMessagesArray[0]))
            
        print("MESSAGE QUANTITY: \(messages.count)")
        
//        picker.delegate = self as UIImagePickerControllerDelegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
//        
//        self.sender = AuthProvider.Instance.userID()
//        self.senderDisplayName = AuthProvider.Instance.userName
//        MessagesHandler.Instance.delegate = self as! MessageReceivedDelegate
        

        
    }
    


    
    //MARK: MESSAGE DATA FOR ITEM AT INDEX PATH
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        print("MESSAGE QUANTITY 2: \(messages.count)")
//        return messages.count > 0 ? self.messages[indexPath.item] : JSQMessage(senderId: senderId, senderDisplayName: title, date: dateArray[0], text: textMessagesArray[0]) as JSQMessageData

        return self.messages[indexPath.item]
        
    }

    //MARK: NUMBER OF ITEMS IN SECTION
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //MARK: OUTGOING MESSAGE
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    //MARK: INCOMING MESSAGE
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    //Set bubble image depends on sender
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == title{
            return incomingBubbleImageView
        } else {
            return outgoingBubbleImageView
        }
    }
    
    //MARK: AVATAR
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
//        let avatar = avatarImage
//        return avatar as! JSQMessageAvatarImageDataSource //as JSQMessageAvatarImageDataSource
        return JSQMessagesAvatarImageFactory.avatarImage(with: avatarImage, diameter: UInt(Key.avatarDiametr))
    }
    
    //MARK: CREATE MESSAGE
    private func addMessage(senderId: String!, senderDisplayName: String!, date: Date!, text: String!) {
        if let message = JSQMessage(senderId: self.senderId, senderDisplayName: title, date: dateArray[0], text: textMessagesArray[0]) {//(id: senderId, name: title, text: textMessagesArray[0]) {
        messages.append(message)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        for i in textMessagesArray {
//            var n = 0
//            let singleMessage = addMessage(senderId: senderId, senderDisplayName: senderId, date: dateArray[n], text: i)
//            n += 1
//            print("Message count = \(messages.count)")
//        }
        //        addMessage(senderID: "Clar Alex",  text: "Hey, how are you?")
        //        addMessage(sender: "Nick Rock",  text: "Hey, how are you?")
        //        addMessage(sender: "Nick Rock",  text: "Hey, how are you?")
        //        addMessage(sender: "Clar Alex",  text: ":smile:")
        //        addMessage(sender: "Clar Alex",  text: ":poop:")
        //        addMessage(sender: "Nick Rock",  text: "Hey, how are you?")
        //        addMessage(sender: "Nick Rock",  text: "Hey, how are you?")
        //        addMessage(sender: "Clar Alex",  text: ":poop:")
        //        addMessage(sender: "Clar Alex",  text: "Hey, how are you?")
        //        addMessage(sender: "Clar Alex",  text: "Hey, how are you?")
        //        addMessage(sender: "Clar Alex",  text: "Hey, how are you?")
        //        addMessage(sender: "Clar Alex",  text: "Hey, how are you?")
    }

    
    
    //MARK: CELL FOR ITEM AT
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        cell.avatarImageView.image = avatarImage
        cell.avatarImageView.clipsToBounds = true;
        cell.avatarImageView.layer.cornerRadius = CGFloat(Key.avatarDiametr/2);
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
//        // Use the outlet in our custom class to get a reference to the UILabel in the cell
//        cell.myLabel.text = self.items[indexPath.item]
//        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    //MARK: DID PRESSED SEND
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        //messages.append(JSQMessage(senderId: sender, displayName: sender, text: textMessagesArray[0]))
        //finishSendingMessage()
    }
    
    
    

}
