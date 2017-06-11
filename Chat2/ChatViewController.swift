//
//  ChatTableViewTableViewController.swift
//
//
//  Created by Anna on 07.06.17.
//
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Strings
    let chat = "chat"
    let messages = "messages"
    let json = "json"
    let prototypeCell = "PrototypeCell"
    
    
    var channels = [[String:AnyObject]]()
    var channelsArray = [Channel]()             //6 items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            //print(channels.count)
            
            for channel in channels {
                let newChannel = Channel(dictionary: channel)
                channelsArray.append(newChannel)
                print(newChannel.userName)
                //print(newChannel.user)
                
                
            }
        }
        catch {
            print(error)
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
