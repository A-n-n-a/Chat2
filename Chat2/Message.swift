
import Foundation
import UIKit

struct Message {

    var senderName: String
    var message: String
    var time: Date
    
    
    init(dictionary: [String : AnyObject]) {
        
        var senderFullName = String()
        var text = String()
        var date = Date()
        
        DispatchQueue.global(qos: .background).async {
            let sender = dictionary[Key.sender] as! [String:AnyObject]
            let firstName = sender[Key.firstNameKey] as! String
            let lastName = sender[Key.lastNameKey] as! String
            senderFullName = firstName + " " + lastName
            text = dictionary[Key.textKey] as! String
            
            // time
            var createDateString = dictionary[Key.createDate] as! String
            
            //convert String from json to acceptable format by removing some caracters
            if createDateString.characters.count == 27 {
                let startIndex = createDateString.index(createDateString.startIndex, offsetBy: 19)
                let endIndex = createDateString.index(createDateString.startIndex, offsetBy: 26)
                createDateString.removeSubrange(startIndex ..< endIndex)

            }
            // String -> Date -> String
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = dateFormatter.date(from: createDateString)!
            dateFormatter.dateFormat = "dd-MMM HH:mm"
        }

        self.senderName = senderFullName
        self.message = text
        self.time = date
    }
    
    
    
    
}
