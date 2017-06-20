
import Foundation
import UIKit

struct Channel {
    var channelID: Int
    var userName: String
    var lastMessage: String
    var unreadMessageCount: Int
    var photo: UIImage
    let time: String
    
    
    init(dictionary: [String : AnyObject]) {
        
        let id = dictionary[Key.idKey] as! Int
        let user = dictionary[Key.usersKey] as! [[String:AnyObject]]
        let interlocutor = user[0] as [String:AnyObject]
        let firstName = interlocutor[Key.firstNameKey] as! String
        let lastName = interlocutor[Key.lastNameKey] as! String
        let userName = firstName + " " + lastName
        let lastMessage = dictionary[Key.lastMessageKey] as! [String:AnyObject]
        let text = lastMessage[Key.textKey] as! String
        let unread = dictionary[Key.unreadMessagesCountKey] as! Int
        
        let photoString = interlocutor[Key.photoKey] as! String
        let photoURL = NSURL(string: photoString)
        let photoData = try? Data(contentsOf: photoURL! as URL)
        
        var createDateString = lastMessage[Key.createDate] as! String
        
        //convert String from json to acceptable format by removing some caracters
        if createDateString.characters.count == 27 {
            let startIndex = createDateString.index(createDateString.startIndex, offsetBy: 19)
            let endIndex = createDateString.index(createDateString.startIndex, offsetBy: 26)
            createDateString.removeSubrange(startIndex ..< endIndex)
            print(createDateString)
        }
        // String -> Date -> String
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: createDateString)
        dateFormatter.dateFormat = "dd-MMM HH:mm"
        dateFormatter.locale = tempLocale // reset the locale
        let createDate = dateFormatter.string(from: date!)
       
        self.channelID = id
        self.userName = userName
        self.lastMessage = text
        self.unreadMessageCount = unread
        self.photo = UIImage(data: photoData!)!
        self.time = createDate
    }
}
