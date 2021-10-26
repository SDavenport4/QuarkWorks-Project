//
//  AlbumDetailViewController.swift
//  QuarkWorks Project
//
//  Created by Shawn Davenport on 10/20/21.
//

import UIKit
import CoreData

class AlbumDetailViewController: UIViewController {
    
    // Album variable from the Segue
    var album: Album?
    // Rank variable from Segue since not from the API JSON
    var albumRank: String?
    
    // Array off all favorite album ids
    var favorites: [String] = []
    
    // Pull in the User defaults object to access favorites
    var userDefaults = UserDefaults.standard
    
    // Outlets for the Detail ViewController
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var advisoryRating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favorites = userDefaults.array(forKey: "favorites") as? [String] ?? [String]()
        
        // Set the image view to the URL data - Force unwrapping, not safe
        setImage(from: (album?.artworkUrl)!)
        songName.text = album?.name ?? "N/A"
        artistName.text = album?.artistName ?? "N/A"
        rank.text = "Rank: \(albumRank ?? "N/A")"
        
        // Loop through the Album genres and put each Genre name into an array
        var genreNames = [String]()
             
        for i in 0..<(album?.genres?.count ?? 0){
            genreNames.append((album?.genres![i].name)!)
        }
        
        // Check if the current album ID is in the facvorites and set the Favorite button icon accordingly
        if favorites.contains(where: {$0 == (album?.id ?? "N/A")}){
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        // Join the Genre names with a comma
        genres.text = "Genres: \(genreNames.joined(separator: ", "))"
        
        advisoryRating.text = "Advisory Rating: \(album?.advisoryRating ?? "N/A")"
        releaseDate.text = "Release Date: \(album?.releaseDate ?? "N/A")"
        
    }
    
    // Called when the Favorite icon is clicked to add / remove to favorites and update the icon
    @IBAction func favoriteClick(_ sender: UIButton) {
        if favorites.contains(where: {$0 == (album?.id ?? "N/A")}){
            favorites.removeAll(where: {$0 == (album?.id ?? "N/A")})
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }else{
            favorites.append((album?.id ?? "N/A"))
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        userDefaults.set(favorites, forKey: "favorites")
    }
    
    // Sets the image view to the Data from the Artwork URL
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        // Run async to not freeze the UI
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.artwork.image = image
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
