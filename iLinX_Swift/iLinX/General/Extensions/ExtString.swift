//
//  ExtString.swift
//  iLinX
//
//  Created by Vikas Ninawe on 23/10/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//  Purpose: This is used to perform various string operations.

import Foundation

extension String{
    
    // Capitalized First letter of the word
    func capitalizingFirstLetter() -> String{
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter(){
        self = self.capitalizingFirstLetter()
    }
    
    // Get the length of the string
    var length : Int{
        return self.count
    }
    
    // Localised string for different languages
    var localized: String{
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    // remove whites spaces (" ")
    func removingWhitespaces() -> String{
        return replacingOccurrences(of: " ", with: "")
    }
    
    // replace spaces with %20 for url string and replace other language char with allowed char
    func replacingSpacesWithPercentTwenty() -> String{
        //"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~`!@#$%^&*()+=-/;:\"\'{}[]<>^?, "
        //return replacingOccurrences(of: " ", with: "%20")
        //return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        let str = self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!;
        return str.replacingPercentTwentyFiveWithPercent()
    }
    
    // replace %25 with % to load encoded url (having multiple language chars) in webview or imageview
    func replacingPercentTwentyFiveWithPercent() -> String{
        return replacingOccurrences(of: "%25", with: "%")
    }
    
    // get all substrings separated by char
    func getSubStringsSeparatedBy(separatedBy:String) -> [String]{
        return self.components(separatedBy: separatedBy)
    }
    
    // get all the occurances of carriage return char
    func getCarriageReturnCount() -> Int{
        let arrStr = self.components(separatedBy: "\r")
        return arrStr.count > 0 ? arrStr.count-2 : 0
    }
    
    // get all the occurances of newline char
    func getNewLineCount() -> Int{
        let arrStr = self.components(separatedBy: "\n")
        return arrStr.count > 0 ? arrStr.count-2 : 0
    }
    
    // remove multiple "\r" characters
    func removeCarriageReturn() -> String{
        return replacingOccurrences(of: "\r", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    // remove multiple "\n\n" characters
    func removeMultipleNewLine() -> String{
        return replacingOccurrences(of: "\n\n", with: "\n", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    // remove &nbsp; from html text
    func removeNBSP() -> String{
        return replacingOccurrences(of: "&nbsp;", with: " ")
    }
    
    func replaceAposWithApos() -> String{
        return replacingOccurrences(of: "Andapos;", with: "'")
    }
    
    // remove m2 from string
    func removeSquareMetre() -> String{
        return replacingOccurrences(of: "M2", with: "")
    }
    
    // remove amp; from string
    func removeAMPSemicolon() -> String{
        return replacingOccurrences(of: "amp;", with: "")
    }
    
    // replace "&" with "And" from string
    func replaceAnd() -> String{
        return replacingOccurrences(of: "&", with: "And")
    }
    
    // replace "\n" with "" from string
    func removeNewLine() -> String{
        return replacingOccurrences(of: "\n", with: "")
    }
    
    // replace "\" with "" from string
    func removeSlash() -> String{
        return replacingOccurrences(of: "\\", with: "")
    }
    
    // remove all HTML tags from string
    func removeHTMLTags() -> String{
        var str = self.removeNBSP()
        str = str.removeCarriageReturn()
        str = str.removeMultipleNewLine()
        return str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    // remove leading and trailing spaces
    mutating func removeLeadingTrailingSpaces() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // detect links from html text if any
    func detectLinks() -> [String]{
        var arrLinks = [String]()
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: (self.utf16.count)))
        
        for match in matches{
            let url = (self as NSString).substring(with: match.range)
            arrLinks.append(url.removeHTMLTags())
        }
        return arrLinks
    }
    
    // remove links from html text if any
    func removeLinks() -> String{
        let links:[String] = self.detectLinks()
        var str = self
        _ = links.map { str = str.replacingOccurrences(of: $0, with: "") }
        return str;
    }
    
    // Encode Emoji
    var encodeEmoji: String?{
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        return encodedStr as String?
    }
    
    // Decode Emoji
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if data != nil{
            let valueUniCode = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue) as String?
            if valueUniCode != nil{
                return valueUniCode!
            }else{
                return self
            }
        }else{
            return self
        }
    }
    
    //Convert String to dictionary
    func convertToDictionary() -> [String: Any]?{
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                //print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    // for getting substring in range
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}


// Used in appDelegate

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}


