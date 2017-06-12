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

class MessengerViewController: JSQMessagesViewController {
    
    var channelRef: DatabaseReference?
    var channel: Channel?
    
    var chatTitle = ""
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private lazy var messageRef: DatabaseReference = self.channelRef!.child(Key.messages)
    private var newMessageRefHandle: DatabaseReference?
    
    var textMessagesArray = [String]()
    var messages = [JSQMessage]()

    var sendersNameArray = [String]()
    var avatarImage = UIImage()
    var dateArray = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = chatTitle
        
        self.senderId = " "
        self.senderDisplayName = " "
        
        //fill mesagges array with default messages from json file
        var n = 0
        for i in textMessagesArray {
          
            let singleMessage = JSQMessage(senderId: sendersNameArray[n], senderDisplayName: sendersNameArray[n], date: dateArray[n], text: i)
            messages.append(singleMessage!)
            self.senderId = sendersNameArray[n]
             print("SENDER ID: \(self.senderId!)")
            self.senderDisplayName = sendersNameArray[n]
            print("SENDER DISPLAY NAME: \(self.senderDisplayName!)")
            print("N: \(n)")
            n += 1
            print("N2: \(n)")
            print("Message count = \(messages.count)")
        }
        

        
    }
    
    //MARK: NUMBER OF ITEMS IN SECTION
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //MARK: MESSAGE DATA FOR ITEM AT INDEX PATH
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {

        return self.messages[indexPath.item]
        
    }
    
    //MARK: OUTGOING MESSAGE
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    //MARK: INCOMING MESSAGE
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    //Set bubble image depends on sender
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        print(message.senderId)
        if message.senderId == senderId{
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    //MARK: AVATAR
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId{
            return nil
        } else {
            return JSQMessagesAvatarImageFactory.avatarImage(with: avatarImage, diameter: UInt(Key.avatarDiametr))
        }
    }
    
    //MARK: CREATE MESSAGE
    private func addMessage(senderId: String!, senderDisplayName: String!, date: Date!, text: String!) {
        if let message = JSQMessage(senderId: self.senderId, senderDisplayName: title, date: dateArray[0], text: textMessagesArray[0]) {//(id: senderId, name: title, text: textMessagesArray[0]) {
        messages.append(message)
        }
    }
   
    //MARK: CELL FOR ITEM AT
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        
        return cell
    }
    
    //MARK: DID PRESSED SEND
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            Key.senderId: senderId,
            Key.senderDisplayName: senderDisplayName,
            Key.date: String(describing: date),
            Key.textKey: text
        ] as [String : Any]
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()

    }
    
//    private func observeMessages() {
//        messageRef = channelRef!.child(Key.messages)
//        //let messageQuery = messageRef.queryLimited(toLast: 25)
//        
//        newMessageRefHandle = messageRef.observe(.childAdded, with: { (snapshot) -> Void in
//            let messageData = snapshot.value as! [String:String]
//            if let senderId = messageData[Key.senderId] as String!, let senderDisplayName = messageData[Key.senderDisplayName] as String!, let date = String(messageData[Key.date]), let text = messageData[Key.textKey] as String!, text.characters.count > 0 {
//                self.addMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
//                self.finishReceivingMessage()
//            } else {
//                print("Error! Could not decode message data")
//            }
//        })
//  
//    }
    

}
