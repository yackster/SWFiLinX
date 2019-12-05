//
//  ModelSetting.swift
//  iLinX
//
//  Created by Vikas Ninawe on 22/03/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import Foundation

class ModelSetting{
    
    static var settingData = [
        ["heading":"connectedtoip".localized,"details":[]],
        ["heading":"directiontouse".localized,"details":[
            ["info":"Your mobile device and Netstream's system must be connected to same wifi router.\nDevices must be in range of 10 metre's.\n... "]
            ]],
        ["heading":"aboutus".localized,"details":[
            ["info":"We are the organization where ..."]
            ]],
        ["heading":"contactus".localized,"details":[
            ["info":"125/2, Sainiketan Colony,\n kalas Road, Visharant Wadi,\n Pune, Maharashtra 411015"]
            ]],
        ["heading":"App Version is, V-1.0, Build-1","details":[]]
    ]
}

struct Detail : Codable {
    let info : String?
}

struct Heading : Codable {
    let heading : String?
    let details : [Detail]?
}

public class DictionaryDecoder {
    
    public init() {
    }
    
    private let decoder = JSONDecoder()
    
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        set { decoder.dateDecodingStrategy = newValue }
        get { return decoder.dateDecodingStrategy }
    }
    
    public var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        set { decoder.dataDecodingStrategy = newValue }
        get { return decoder.dataDecodingStrategy }
    }
    
    public var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        set { decoder.nonConformingFloatDecodingStrategy = newValue }
        get { return decoder.nonConformingFloatDecodingStrategy }
    }
    
    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        set { decoder.keyDecodingStrategy = newValue }
        get { return decoder.keyDecodingStrategy }
    }
    
    public func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(type, from: data)
    }
}

public class DictionaryEncoder {
    
    public init() {
    }
    
    private let encoder = JSONEncoder()
    
    public var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        set { encoder.dateEncodingStrategy = newValue }
        get { return encoder.dateEncodingStrategy }
    }
    
    public var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        set { encoder.dataEncodingStrategy = newValue }
        get { return encoder.dataEncodingStrategy }
    }
    
    public var nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy {
        set { encoder.nonConformingFloatEncodingStrategy = newValue }
        get { return encoder.nonConformingFloatEncodingStrategy }
    }
    
    public var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        set { encoder.keyEncodingStrategy = newValue }
        get { return encoder.keyEncodingStrategy }
    }
    
    public func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }
}

