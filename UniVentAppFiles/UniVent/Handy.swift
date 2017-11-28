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

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}

extension String {
    func safelyLimitedTo(length n: Int)->String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
}

/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

extension UIImage {
    
    public func maskWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
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
    let array: [Any]? = string?.components(separatedBy: "^")
    
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
        string.append("^")
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

func updateTextFont(_ textView: UITextView) {
    if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize(width: 0, height: 0))) {
        return;
    }
    let textViewSize = textView.frame.size;
    let fixedWidth = textViewSize.width;
    let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))

    var expectFont = textView.font;
    if (expectSize.height > textViewSize.height) {
        while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
            expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
            textView.font = expectFont
        }
    }
    else {
        while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
            expectFont = textView.font;
            textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
        }
        textView.font = expectFont;
    }
}

extension UIColor {
    static func appleBlue() -> UIColor {
        return UIColor.init(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
    }
}


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


