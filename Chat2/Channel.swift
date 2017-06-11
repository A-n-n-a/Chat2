
import Foundation
import UIKit

struct Channel {
    var userName: String
    var lastMessage: String
    //var id: Int
    var unreadMessageCount: Int
    var photo: UIImage
    let time: String
    
    /*init(user: [[String:AnyObject]], lastMessage: [String:AnyObject], id: Int, unreadMessageCount: Int) {
        self.user = user
        self.lastMessage = lastMessage
        self.id = id
        self.unreadMessageCount = unreadMessageCount
    }*/
    
    init(dictionary: [String : AnyObject]) {
        
        let user = dictionary[Key.usersKey] as! [[String:AnyObject]]
        let interlocutor = user[0] as [String:AnyObject]
        let userName = "\(String(describing: interlocutor[Key.firstNameKey]))" + " " + "\(String(describing: interlocutor[Key.lastNameKey]))"
        let lastMessage = dictionary[Key.lastMessageKey] as! [String:AnyObject]
        let text = lastMessage[Key.textKey] as! String
        let createDate = lastMessage[Key.createDate] as! String
        let unread = dictionary[Key.unreadMessagesCountKey] as! Int
        let photoString = interlocutor[Key.photoKey] as! String
        let photoURL = NSURL(string: photoString)
        let photoData = try? Data(contentsOf: photoURL! as URL)
       
        
        self.userName = userName
        self.lastMessage = text
        self.unreadMessageCount = unread
        self.photo = UIImage(data: photoData!)!
        self.time = createDate
    }
}
