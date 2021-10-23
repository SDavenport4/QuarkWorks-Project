//
//  AlbumViewCell.swift
//  QuarkWorks Project
//
//  Created by Shawn Davenport on 10/19/21.
//

import UIKit

class AlbumViewCell: UITableViewCell {
    
    // Outlets from the Cell ViewController
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var favoriteIcon: UIButton!
    
    // Update the text in the cells as well as get the image
    func UpdateCellView(album: Album, albumRank: Int, favorite: String){
        songName.text = "\(albumRank). \(album.name ?? "Undefined")"
        artistName.text = album.artistName
        
        favoriteIcon.setImage(UIImage(systemName: favorite), for: .normal)
        
        // Not safe, as if the API call does not bring in a URL, the app explodes.
        setImage(from: album.artworkUrl!)
    }
    
    // Sets the imageview to the correct image from the data
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.artwork.image = image
            }
        }
    }
}
