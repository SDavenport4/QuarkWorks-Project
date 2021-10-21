//
//  AlbumDetailViewController.swift
//  QuarkWorks Project
//
//  Created by Shawn Davenport on 10/20/21.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    var album: Album?
    var albumRank: String?
    
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var advisoryRating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the image view to the URL data - Force unwrapping, not safe
        setImage(from: (album?.artworkUrl)!)
        songName.text = album?.name!
        artistName.text = album?.artistName!
        rank.text = "Rank: \(albumRank ?? "N/A")"
        
        var genreNames = [String]()
             
        for i in 0..<(album?.genres?.count)!{
            genreNames.append((album?.genres![i].name)!)
        }
        
        genres.text = "Genres: \(genreNames.joined(separator: ", "))"
        
        advisoryRating.text = "Advisory Rating: \(album?.advisoryRating! ?? "N/A")"
        releaseDate.text = "Release Date: \(album?.releaseDate! ?? "N/A")"
        
    }
    
    
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
