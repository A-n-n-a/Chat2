
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
    private var newMessageRefHandle: DatabaseHandle?
    
    var textMessagesArray = [String]()
    var messages = [JSQMessage]()
    var totalMessagesArray = [JSQMessage]()

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
            if messages[0].senderId == chatTitle {
                totalMessagesArray = messages
            } else {
                totalMessagesArray = [JSQMessage]()
            }
            self.senderId = sendersNameArray[n]
            self.senderDisplayName = sendersNameArray[n]
            n += 1
        }
        
        observeMessages()
        
    }
    
    //MARK: NUMBER OF ITEMS IN SECTION
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalMessagesArray.count
    }
    
    //MARK: MESSAGE DATA FOR ITEM AT INDEX PATH
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {

        return self.totalMessagesArray[indexPath.item]
        
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
        let message = totalMessagesArray[indexPath.item]
        if message.senderId == senderId{
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    //MARK: AVATAR
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = totalMessagesArray[indexPath.item]
        if message.senderId == senderId{
            return nil
        } else {
            return JSQMessagesAvatarImageFactory.avatarImage(with: avatarImage, diameter: UInt(Key.avatarDiametr))
        }
    }
    
    //MARK: CREATE MESSAGE
    private func addMessage(senderId: String!, senderDisplayName: String!, date: Date!, text: String!) {
        
        if let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) {
            totalMessagesArray.append(message)
            
        }
    }
   
    //MARK: CELL FOR ITEM AT
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = totalMessagesArray[indexPath.item]
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
    
    private func observeMessages() {
        messageRef = channelRef!.child(Key.messages)
        
        DispatchQueue.global(qos: .background).async {
            self.newMessageRefHandle = self.messageRef.observe(.childAdded, with: { (snapshot) -> Void in
                let messageData = snapshot.value as! [String:String]
                let senderId = messageData[Key.senderId] as String!
                let senderDisplayName = messageData[Key.senderDisplayName] as String!
                var createDate =  messageData[Key.date]!
                
                // String to be conformed to Date Format
                if createDate.characters.count == 25 {
                    let startIndex = createDate.index(createDate.startIndex, offsetBy: 19)
                    let endIndex = createDate.index(createDate.startIndex, offsetBy: 20)
                    createDate.removeSubrange(startIndex ..< endIndex)
                    createDate = createDate.replacingOccurrences(of: " ", with: "T")
                }

                if createDate.characters.count == 27 {
                    let startIndex = createDate.index(createDate.startIndex, offsetBy: 19)
                    let endIndex = createDate.index(createDate.startIndex, offsetBy: 25)
                    createDate.removeSubrange(startIndex ..< endIndex)

                }
                // String -> Date -> String
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from: createDate)
                dateFormatter.dateFormat = "dd-MMM HH:mm"
                
                
                let text = messageData[Key.textKey] as String!
                if (text?.characters.count)! > 0 {
                    self.addMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date!, text: text)
                    self.finishReceivingMessage()
                } else {
                    print("Error! Could not decode message data")
                }
            })
        }
  
    }
    

}
