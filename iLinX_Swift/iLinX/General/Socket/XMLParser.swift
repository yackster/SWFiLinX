//
//  XMLParser.swift
//  iLinX
//
//  Created by Vikas Ninawe on 03/12/18.
//  Copyright © 2018 Redbytes Software. All rights reserved.
//

import Foundation

//MARK: Used to parse xml data receiving from query response

class ParseXMLData<T:Appendable>: NSObject, XMLParserDelegate {
    
    var parser: XMLParser
    var arrObj = [T]()
    
    init(xml: String) {
        parser = XMLParser(data: xml.data(using: String.Encoding.utf8)!)
        super.init()
        parser.delegate = self
    }
    
    func parseXML() -> [T] {
        parser.parse()
        return arrObj
    }

    // MARK: XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        //print("\n Start elementName \n",elementName,namespaceURI,qName)
        if let obj = T.init(element:elementName, dictionary: attributeDict) {
            arrObj.append(obj)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //print("\n End elementName \n",elementName,namespaceURI,qName)
    }
}

//MARK: Used to parse xml data in xml file recieved from Netstream system

class ParseXMLFileData: NSObject, XMLParserDelegate {
    
    var parser: XMLParser
    var elementArr = [String]()
    var arrayElementArr = [String]()
    var str = "{"
    
    init(xml: String) {
        parser = XMLParser(data: xml.replaceAnd().replaceAposWithApos().data(using: String.Encoding.utf8)!)
        super.init()
        parser.delegate = self
    }
    
    func parseXML() -> String {
        parser.parse()
        
        // Do all below steps serially otherwise it may lead to wrong result
        for i in self.elementArr{
            if str.contains("\(i)@},\"\(i)\":"){
                if !self.arrayElementArr.contains(i){
                    self.arrayElementArr.append(i)
                }
            }
            str = str.replacingOccurrences(of: "\(i)@},\"\(i)\":", with: "},") //"\(element)@},\"\(element)\":"
        }
        
        for i in self.arrayElementArr{
            str = str.replacingOccurrences(of: "\"\(i)\":", with: "\"\(i)\":[") //"\"\(arrayElement)\":}"
        }
        
        for i in self.arrayElementArr{
            str = str.replacingOccurrences(of: "\(i)@}", with: "\(i)@}]") //"\(arrayElement)@}"
        }

        for i in self.elementArr{
            str = str.replacingOccurrences(of: "\(i)@", with: "") //"\(element)@"
        }
        
        // For most complex xml (You can ommit this step for simple xml data)
        self.str = self.str.removeNewLine()
        self.str = self.str.replacingOccurrences(of: ":[\\s]?\"[\\s]+?\"#", with: ":{", options: .regularExpression, range: nil)
        
        return self.str.replacingOccurrences(of: "\\", with: "").appending("}")
    }
    
    // MARK: XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        //print("\n Start elementName: ",elementName)
        
        if !self.elementArr.contains(elementName){
            self.elementArr.append(elementName)
        }
        
        if self.str.last == "\""{
            self.str = "\(self.str),"
        }
        
        if self.str.last == "}"{
            self.str = "\(self.str),"
        }
        
        self.str = "\(self.str)\"\(elementName)\":{"
        
        var attributeCount = attributeDict.count
        for (k,v) in attributeDict{
            //print("key: ",k,"value: ",v)
            attributeCount = attributeCount - 1
            let comma = attributeCount > 0 ? "," : ""
            self.str = "\(self.str)\"_\(k)\":\"\(v)\"\(comma)" // add _ for key to differentiate with attribute key type
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.str.last == "{"{
            self.str.removeLast()
            self.str = "\(self.str)\"\(string)\"#" // insert pattern # to detect found characters added
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //print("\n End elementName \n",elementName)
        if self.str.last == "#"{ // Detect pattern #
            self.str.removeLast()
        }else{
            self.str = "\(self.str)\(elementName)@}"
        }
    }
}



