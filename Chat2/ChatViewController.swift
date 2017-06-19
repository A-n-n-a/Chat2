//
//  ChatTableViewTableViewController.swift
//
//
//  Created by Anna on 07.06.17.
//
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Strings
    let chat = "chat"
    let messages = "messages"
    let json = "json"
    let prototypeCell = "PrototypeCell"
   
    
    
    var channels = [[String:AnyObject]]()
    var channelsArray = [Channel]()             //6 items
    //var newChannel = Channel(dictionary: channels)
    var messagesDict = [[String:AnyObject]]()
    var messagesArray = [Message]()
    var textMessagesArray = [String]()
    var interlocutorsArray = [String]()
    var sendersArray = [String]()
    var messageDateArray = [Date]()
    
    var selectedRow = UITableViewCell()
    
    private lazy var channelRef: DatabaseReference = Database.database().reference().child(Key.idKey)
    private var channelRefHandle: DatabaseHandle?
    
    //MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //observeChannels()
        
        self.tableView.reloadData()
        
        //MARK: JSON chat.json
        
        guard let path = Bundle.main.path(forResource: chat, ofType: json) else {
            return
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let myJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //print("JSON\n\(myJson)")
            let dict = myJson as! [String: AnyObject]
            //print(dict)
            
            let channels = dict["channels"] as! [[String:AnyObject]]
            print(channels.count)
            
            for channel in channels {
                var newChannel = Channel(dictionary: channel)
                channelsArray.append(newChannel)
                interlocutorsArray.append(newChannel.userName)
                //print(newChannel.userName)
                
                
            }
            
            
        }
        catch {
            print(error)
        }
        
        //MARK: JSON messeges.json
        guard let messagePath = Bundle.main.path(forResource: messages, ofType: json) else {
            return
        }
        let messageUrl = URL(fileURLWithPath: messagePath)
        
        do {
            let data = try Data(contentsOf: messageUrl)
            let myJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //print("JSON\n\(myJson)")
            let dict = myJson as! [String: AnyObject]
            //print(dict)
            
            let messagesDict = dict["messages"] as! [[String:AnyObject]]
            //                print(messages.count)
            
            for message in messagesDict {
                let newMessage = Message(dictionary: message)
                messagesArray.append(newMessage)
                messageDateArray.append(newMessage.time)
                sendersArray.append(newMessage.senderName)
                print(newMessage)
                //print(newMessage.message)
                //print(newChannel.user)
                
                
            }
            
        }
        catch {
            print(error)
        }
        
        for i in messagesArray {
            print("MESSAGE: \(i.message)")
            textMessagesArray.append(i.message)
            
        }

        print("MESSAGE: \(messagesArray.count)")
        print("INTER: \(interlocutorsArray)")
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    

    // MARK: - Table view data source

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return channelsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: prototypeCell, for: indexPath) as! PrototypeCell
        
        let channel = channelsArray[indexPath.row]
        
        cell.customInit(userpic: channel.photo, nameLabel: channel.userName, messageLabel: channel.lastMessage, timeLabel: channel.time, unreadLabel: String(channel.unreadMessageCount))
        
        if cell.unreadLabel.text == "0" {
            cell.unreadLabel.isHidden = true
        } else {
            cell.unreadLabel.layer.cornerRadius = 11     // Round Views
            
        }
   
        
        return cell
    }
    //MARK: PREPARE SEGUE
    // Pass date to next VC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destViewController = segue.destination as! MessengerViewController
        
        //парсим массив на структуры, индекс элемента массива - номер выбранной строки
        
        let selectedRowIndex = self.tableView.indexPathForSelectedRow
        selectedRow = self.tableView.cellForRow(at: selectedRowIndex!)!
        
        destViewController.chatTitle = interlocutorsArray[(selectedRowIndex?.row)!]
        
//        print(channels.count)
//        print(channelsArray.count)

        
        let newChannel = channelsArray[(selectedRowIndex?.row)!]
        destViewController.textMessagesArray = textMessagesArray
        //destViewController.sender = interlocutorsArray[(selectedRowIndex?.row)!]
        
        destViewController.senderDisplayName = interlocutorsArray[(selectedRowIndex?.row)!]
        destViewController.channel = newChannel
        destViewController.channelRef = channelRef.child(String(newChannel.channelID))
        destViewController.avatarImage = newChannel.photo
        destViewController.dateArray = messageDateArray
        destViewController.sendersNameArray = sendersArray
    }
    
                
    // row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 70
    }
    
    //delete row by swiping
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            channelsArray.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//    }
    
//    private func observeChannels() {
//        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
//           let channelData = snapshot.value as! [String:AnyObject]
//            print("CHANNELDATA: \(channelData)")
//            let chan = Channel(dictionary: channelData)
//            //let id = snapshot.key
//            
//            if let channelID = chan.channelID as? Int, chan.channelID >  0 {
//                self.channelsArray.append(chan)
//                self.tableView.reloadData()
//            } else {
//                print("Error! Could not decode channel data")
//            }
//        })
//    }
    
    
}
