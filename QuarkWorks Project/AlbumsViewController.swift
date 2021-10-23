//
//  AlbumsViewController.swift
//  QuarkWorks Project
//
//  Created by Shawn Davenport on 10/19/21.
//

import UIKit
import CoreData

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlets from the ViewController
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Favorite album array
    var favorites: [String] = []
    
    // Get the user defaults object to access favorites from disk
    var userDefaults = UserDefaults.standard
    
    var fetchData = FetchData()
    var albums = [Album]() {
        didSet{
            // Called once the data is populated into array.
            DispatchQueue.main.async {
                // Reload Table View data
                self.tableView.reloadData()
                
                // Hide the view from above the table view
                self.activityView.isHidden = true
                
                // Stop the Activity Indicator from spinning (Also hides it)
                self.activityIndicator.stopAnimating()
                
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                
            }
        }
    }
    
    // Values to show in the picker view. Range of albums allowed to pull in
    let numbers = Array(1...100)
    
    // Amount to pull from the API
    var amount: Int = 25
    
    
    
    
    override func viewDidLoad() {
        
        // Show Activity Indicator
        self.activityIndicator.startAnimating()
        
        // Call the fetch data method to call the API and set data
        getAlbums()
        
        amountLabel.text = "Albums Displayed: \(self.amount)"
        
        
        
        pickerView.isHidden = true
        
        
        super.viewDidLoad()
        
        // Setting delegate and datasource on pickerView and tableView
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Collect the favorite albums from the phone and reload the tableview
        favorites = userDefaults.array(forKey: "favorites") as? [String] ?? [String]()
        tableView.reloadData()
    }

    
    
    // Call to fetch the albums with the amount selected from the pickerView
    func getAlbums(){
        // Call the fetch data method to call the API and set data
        fetchData.fetchData(amount: self.amount) { albums in
            do {
                self.albums = albums
            }
        }
    }
    
    // Get which row button was clicked and update in favorites array and update ico=-p
    @IBAction func favoriteAlbumClick(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is AlbumViewCell){
            superview = view.superview
        }
        
        guard let cell = superview as? AlbumViewCell else {
            return
        }
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let currentAlbum: Album = albums[indexPath.row]
        
        
        if favorites.contains(where: {$0 == currentAlbum.id!}){
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            favorites.removeAll(where: {$0 == currentAlbum.id!})
        }else{
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favorites.append(currentAlbum.id!)
        }
        userDefaults.set(favorites, forKey: "favorites")
        
    }
    
    
    // When the "Change" button is clicked, show the activity view and the pickerView
    @IBAction func onClick(_ sender: Any) {
        self.activityView.isHidden = false
        self.pickerView.isHidden = false
        self.doneButton.isHidden = false
        self.pickerView.selectRow(self.amount - 1, inComponent: 0, animated: false)
    }
    
    
    // Displays each cell for each album in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumViewCell {
            
            // Get current cell, and get the album from that row index from Album array
            let currentAlbum = albums[indexPath.row]
            
            var design: String = ""
            
            if favorites.contains(where: {$0 == currentAlbum.id!}){
                design = "star.fill"
            }else{
                design = "star"
            }
            
            // Update the cell properties to the Album values
            cell.UpdateCellView(album: currentAlbum, albumRank: indexPath.row + 1, favorite: design)
            
            return cell
        }else{
            return AlbumViewCell()
        }
        
    }
    
    // Return the number of albums in our one section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    // Return number of sections in the tableview.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // Used to send the tapped Album to the segue and display the detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AlbumDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
            destination.album = albums[indexPath.row]
            destination.albumRank = "\(indexPath.row + 1)"
        }

    }
    
    // Returns 1 as there is only 1 component. Could be 2 for a favorites category
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the size of the numbers array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    
    // Sets up all the items in the pickerview from the array of numbers
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = numbers[row]
        return "\(title)"
    }
    
    // Called when Done is clicked on the picker view. Processes the API call
    
    @IBAction func doneClicked(_ sender: Any) {
        self.pickerView.isHidden = true
        self.doneButton.isHidden = true
        self.activityView.isHidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        self.amountLabel.text = "Albums Displayed: \(self.amount)"
        getAlbums()
    }
    
    // Update amount of albums when selected in pickerview
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        amount = numbers[row]
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
