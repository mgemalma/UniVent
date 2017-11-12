import UIKit
import SystemConfiguration

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fixField), for: .editingChanged)
        }
    }
    func fixField(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String {
    func safelyLimitedTo(length n: Int)->String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
}

func connectedToNetwork() -> (connected: Bool, cellular: Bool) {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return (false, false)
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return (false, false)
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    let cellular = flags.contains(.isWWAN)
    
    return ((isReachable && !needsConnection), cellular)
}


final class Reachability {
    
    private init () {}
    class var shared: Reachability {
        struct Static {
            static let instance: Reachability = Reachability()
        }
        return Static.instance
    }
    
    func isConnectedToNetwork() -> (connected: Bool, cellular: Bool) {
        guard let flags = getFlags() else { return (false,false) }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let cellular = flags.contains(.isWWAN)
        return ((isReachable && !needsConnection), (isReachable && cellular))
    }
    
    private func getFlags() -> SCNetworkReachabilityFlags? {
        guard let reachability = ipv4Reachability() ?? ipv6Reachability() else {
            return nil
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return nil
        }
        return flags
    }
    
    private func ipv6Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in6()
        zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    private func ipv4Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
}

func arrayer(string: String?) -> [Any]? {
    // Nil
    if string == nil {
        return nil
    }
    
    // Parse to Array
    let array: [Any]? = string?.components(separatedBy: ",")
    
    // Return
    return array
}

func stringer(array: [Any]?) -> String? {
    // Nil
    if array == nil {
        return nil
    }
    
    // Parse to String
    var string: String = ""
    for element in array! {
        string.append(String(describing: element))
        string.append(",")
    }
    
    // Remove last +
    //string.removeLast()
    string.remove(at: string.index(before: string.endIndex))
    
    // Return
    return string
}

func dictToString(dict: [String: String]?) -> String? {
    // Nil
    if dict == nil {
        return ""
    }
    
    // Parse to String
    var string: String = "[{"
    for element in dict! {
        string.append("\"")
        string.append(String(describing: element.key))
        string.append("\"")
        string.append(":")
        string.append("\"")
        string.append(String(describing: element.value))
        string.append("\"")
        string.append(",")
    }
    
    // Remove last +
    //string.removeLast()
    string.remove(at: string.index(before: string.endIndex))
    string.append("}")
    string.append("]")
    
    // Return
    return string
}

func dicter(string: String?) -> [String: String]? {
    // Nil
    if string == nil {
        return nil
    }
    // Parse to Array
    let temp = string!.data(using: .utf8)
    let dict = NSEvent.parseEvent(temp!)
    
    // Return
    return dict
}


 func parseID(_ data:Data) -> String? {
    var id2: String?
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
        
        for element in jsonArray {
            let dict = element as! [String:String]
            id2 = dict["uniqueID"]
        }
    }
    catch {
        print("Error in parseID")
    }
    return id2
}

//// Parse Data into a Dictionary
// func parseEvent(_ data:Data) -> [String:String]? {
//    // Dict
//    var dict: [String:String]?
//    
//    // Do
//    do {
//        // Extract JSON
//        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
//        
//        // Extract Dict from JSON
//        for element in jsonArray {
//            let userDict = element as! [String:String]
//            dict = userDict
//        }
//    }
//        
//        // Catch
//    catch {
//        // Print Error Message
//        print("NSEvent: parseEvent() Caught an Exception!")
//    }
//    
//    // Return Dict
//    return dict
//}
//
//
//// Parse Data into an array of dictionaries
// func parseEvents(_ data:Data) -> [[String:String]]? {
//    // Dict
//    var dict: [[String:String]]? = [[String:String]]()
//    
//    // Do
//    do {
//        // Extract JSON
//        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
//        
//        // Extract Dict from JSON
//        for element in jsonArray {
//            let event = element as! [String:String]
//            dict!.append(event)
//        }
//    }
//        
//        // Catch
//    catch {
//        // Print Error Message
//        print("NSEvent: parseEvents() Caught an Exception!")
//    }
//    
//    // Return Dict
//    return dict
//}

// MARK: - Comparators
func BY_DATE_A(a: NSEvent, b: NSEvent) -> Bool {
    return a.getStartTime()! < b.getStartTime()!
}
func BY_DATE_D(a: NSEvent, b: NSEvent) -> Bool {
    return a.getStartTime()! > b.getStartTime()!
}
func BY_RAT_A(a: NSEvent, b: NSEvent) -> Bool {
    return a.getRating()! > b.getRating()!
}
func BY_RAT_D(a: NSEvent, b: NSEvent) -> Bool {
    return a.getRating()! < b.getRating()!
}
func BY_LOC_A(a: NSEvent, b: NSEvent) -> Bool {
    return a.getLocation()!.distance(from: NSUser.getLocation()!) < b.getLocation()!.distance(from: NSUser.getLocation()!)
}
func BY_LOC_D(a: NSEvent, b: NSEvent) -> Bool {
    return a.getLocation()!.distance(from: NSUser.getLocation()!) > b.getLocation()!.distance(from: NSUser.getLocation()!)
}


