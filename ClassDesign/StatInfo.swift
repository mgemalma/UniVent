/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: This class stores statistical information about the event. Synchronization with the database is not implemented.
 **/

class StatInfo {
    /** Instance Variables **/
    private var rating: Double
    private var ratingCount: Int
    private var flagCount: Int
    private var headCount: Int
    
    /** Constructors **/
    // Convenience Constructor only when Creating Event
    convenience init() {
        self.init(rating: -1,ratingCount: 0,flagCount: 0,headCount: 0)
    }
    
    // Main Constructor for Database Event
    init(rating: Int, ratingCount: Int, flagCount: Int, headCount: Int) {
        self.rating = Double(rating)
        self.ratingCount = ratingCount
        self.flagCount = flagCount
        self.headCount = headCount
    }
    
    /** Getters **/
    func getRatingInt() -> Int {
        if rating > 5.0 {
            return 5
        }
        else {
            return Int(rating)
        }
    }
    func getRatingDouble() -> Double {return rating}
    func getRatingCount() -> Int {return ratingCount}
    func getFlagCount() -> Int {return flagCount}
    func getHeadCount() -> Int {return headCount}
    
    /** Setters **/
    func setSmartRating(rating: Double) {
        ratingCount += 1
        if self.rating == -1.0 {
            self.rating = 0.0
        }
        self.rating = ((self.rating * (Double(ratingCount - 1))) + rating)/Double(ratingCount)
    }
    func setSmartFlagCount() {flagCount += 1}
    func setSmartHeadCount() {headCount += 1}
    func setNotSoSmartHeadCount() {headCount = 0}
    func setNotSoSmartFlagCount() {headCount = 0}
}

