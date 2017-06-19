
import Foundation
import UIKit

struct Message {
    //var userName: String
    var senderName: String
    var message: String
    var time: Date
    
   // lazy var senderID: Int
    
    init(dictionary: [String : AnyObject]) {
        
        
        let sender = dictionary[Key.sender] as! [String:AnyObject]
        //let interlocutor = user[0] as [String:AnyObject]
        let firstName = sender[Key.firstNameKey] as! String
        let lastName = sender[Key.lastNameKey] as! String
        let senderName = firstName + " " + lastName
        //let lastMessage = dictionary[Key.lastMessageKey] as! [String:AnyObject]
        let text = dictionary[Key.textKey] as! String
        //let unread = dictionary[Key.unreadMessagesCountKey] as! Int
        
//        let photoString = interlocutor[Key.photoKey] as! String
//        let photoURL = NSURL(string: photoString)
//        let photoData = try? Data(contentsOf: photoURL! as URL)
        
        // time
        var createDateString = dictionary[Key.createDate] as! String
        
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
        //dateFormatter.locale = tempLocale // reset the locale
       // let createDate = dateFormatter.string(from: date!)
        
        
       // self.userName = userName
        self.senderName = senderName
        self.message = text
        self.time = date!
    }
    
//    mutating func customInit(senderID: Int, senderName: String, message: String, time: Date) {
//        self.senderID = senderID
//        self.senderName = senderName
//        self.message = message
//        self.time = time
//        
//
//    }
    
    
    
}
