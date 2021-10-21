//
//  Album.swift
//  QuarkWorks Project
//
//  Created by Shawn Davenport on 10/19/21.
//

import Foundation
import UIKit

// Structure for the Albums
struct Album: Codable {
    var artistID: String?
    var artistName: String?
    var artistUrl: String?
    var artworkUrl: String?
    var id: String?
    var name: String?
    var url: String?
    var genres: [Genre]?
    var advisoryRating: String?
    var releaseDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case artistID
        case artistName
        case artistUrl
        case artworkUrl = "artworkUrl100"
        case id
        case name
        case url
        case genres
        case advisoryRating = "contentAdvisoryRating"
        case releaseDate
    }
    
    struct Genre: Codable {
        
        var name: String?
        
        private enum CodingKeys: String, CodingKey {
            case name
        }
        
    }
    
}

// Parses out the hierarchical
struct Result: Codable {
    
    
    var results: [Album]
    
    // Gets top level JSON key
    private enum CodingKeys: String, CodingKey {
        case feed
    }
    
    // Gets the key from top level we want to look at
    private enum FeedCodingKeys: String, CodingKey {
        case results
    }
    
    // Decodes the JSON from the API call
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let feed = try container.nestedContainer(keyedBy: FeedCodingKeys.self, forKey: .feed)
        
        results = try feed.decode([Album].self, forKey: .results)
    }
    
    
    // Overwrites the default encode function to accept our data
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var feed = container.nestedContainer(keyedBy: FeedCodingKeys.self, forKey: .feed)
        
        try feed.encode(results, forKey: .results)
    }
    
    
    // Parses the results we want and is used to populate the array of Albums in the TableView
    static func parseResults(from data: Data) -> Result? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Result.self, from: data)
            return result
        } catch let error {
            print("Failed to decode: \(error.localizedDescription)")
        }
        return nil
    }
}


