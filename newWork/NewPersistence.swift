//
//  NewPersistence.swift
//  altugggggg
//
//  Created by Altug Gemalmaz on 10/23/17.
//  Copyright © 2017 Altug Gemalmaz. All rights reserved.
//

import Foundation

import Foundation
//This is probably the how the new persistence method should be like
class Persist
{
    
    let wordsArray = "Hi"
    
    
    
    func working()
    {
        let words = File(word: wordsArray)
        print(words.words ?? "Print1"")
            saveWord(words: words.words)
            
        if let loadedWord = self.loadWord() {
            print("Print2")
            print(loadedWord.words ?? "Print3")
            
        }
        
        
        //print(word1)
    }
    
    private func loadWord() -> File? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: File.ArchiveURL.path) as? File
    }
    private func saveWord(words: String?) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(words ?? "Print4", toFile: File.ArchiveURL.path)
        print(isSuccessfulSave)
        
    }
}
