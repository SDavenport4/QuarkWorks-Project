//
//  FetchData.swift
//  QuarkWorks Project
//
//  Created by Shawn Davenport on 10/19/21.
//

import Foundation


class FetchData{
    
    // Fetches API data from the website
    func fetchData(amount: Int, completionHandler: @escaping ([Album]) -> Void) {
        // Initial array for Album Structs
        var albums = [Album]()
        
        // Code to get API data
        let session = URLSession.shared
        
        
        // URL to call to
        let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/\(amount)/albums.json")!

        let task = session.dataTask(with: url) { data, response, error in
            
            // Check if there is no data or there was an error while calling
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            // If bad response from server
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            // Checks if response was actually JSON content
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            // Unwrapps the data object and then passes into the parse function in the struct to populate the Albums array
            if let receivedData = data, let result = Result.parseResults(from: receivedData) {
                albums = try! result.results
                
                // Calls the completion Handler to pass data to our view
                completionHandler(albums)
            }
        }

        task.resume()
    }
    
}
