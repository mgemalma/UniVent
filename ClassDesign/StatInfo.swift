/**
 *  Author: Anirudh Pal & Amjad Zahraa
 *  Description: This class stores statistical information about the event. Synchronization with the database is not implemented.
 **/

class StatInfo {
   
    
    /** Instance Variables **/
    private var rating: Int
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
        self.rating = rating
        self.ratingCount = ratingCount
        self.flagCount = flagCount
        self.headCount = headCount
    }
    
    /** Getters **/
    func getRating() -> Int {return rating}
    func getRatingCount() -> Int {return ratingCount}
    func getFlagCount() -> Int {return flagCount}
    func getHeadCount() -> Int {return headCount}
    
    /** Setters **/
    func setSmartRating(rating: Int) {
        ratingCount += 1
        self.rating = rating/ratingCount
    }
    func setSmartFlagCount() {flagCount += 1}
    func setSmartHeadCount() {headCount += 1}
}

