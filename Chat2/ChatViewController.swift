
import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Strings
    let channelsString = "channels"
    let chat = "chat"
    let messages = "messages"
    let json = "json"
    let prototypeCell = "PrototypeCell"
    let zero = "zero"
   
    var channels = [[String:AnyObject]]()
    var channelsArray = [Channel]()             //6 items
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
        
        self.tableView.reloadData()
        
        DispatchQueue.global(qos: .background).sync {
            
            //MARK: JSON chat.json
            guard let path = Bundle.main.path(forResource: self.chat, ofType: self.json) else {
                return
            }
            let url = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: url)
                let myJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let dict = myJson as! [String: AnyObject]
                
                let channels = dict[channelsString] as! [[String:AnyObject]]
                
                for channel in channels {
                    let newChannel = Channel(dictionary: channel)
                    self.channelsArray.append(newChannel)
                    self.interlocutorsArray.append(newChannel.userName)
                }
                
            }
            catch {
                print(error)
            }
            
            //MARK: JSON messeges.json
            guard let messagePath = Bundle.main.path(forResource: self.messages, ofType: self.json) else {
                return
            }
            let messageUrl = URL(fileURLWithPath: messagePath)
            
            do {
                let data = try Data(contentsOf: messageUrl)
                let myJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let dict = myJson as! [String: AnyObject]
                
                let messagesDict = dict[messages] as! [[String:AnyObject]]
                
                for message in messagesDict {
                    let newMessage = Message(dictionary: message)
                    self.messagesArray.append(newMessage)
                    self.messageDateArray.append(newMessage.time)
                    self.sendersArray.append(newMessage.senderName)
                }
            }
            catch {
                print(error)
            }
        }
        
        for i in messagesArray {

            textMessagesArray.append(i.message)
        }
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
        
        let selectedRowIndex = self.tableView.indexPathForSelectedRow
        selectedRow = self.tableView.cellForRow(at: selectedRowIndex!)!
        
        destViewController.chatTitle = interlocutorsArray[(selectedRowIndex?.row)!]
        
        let newChannel = channelsArray[(selectedRowIndex?.row)!]
        destViewController.textMessagesArray = textMessagesArray
        
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
    
}
