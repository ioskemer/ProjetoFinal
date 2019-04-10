import Foundation
import UIKit

class Alert {
    static func display(_ callerClass: Any, _ title: String, _ message: String, _ button: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
        (callerClass as AnyObject).present(alert, animated: true, completion: nil)
    }
}
