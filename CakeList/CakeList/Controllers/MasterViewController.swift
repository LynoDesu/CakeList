//
//  MasterViewController.swift
//  CakeList
//
//  Created by Adam Bandeira Lynas on 15/04/2019.
//  Copyright © 2019 Limit Break Technology Ltd. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var cakes = [CakeItem]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCakes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cakes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CakeCell", for: indexPath) as! CakeCell

        let cake = cakes[indexPath.row]
        cell.titleLabel.text = cake.title
        cell.descriptionLabel.text = cake.desc
        
        self.downloadImage(imageUrlString: cake.image, imageView: cell.cakeImageView)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func getCakes() {
        let urlString = "https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            	
            do {
                //Decode retrived data with JSONDecoder and assing type of CakeItem object
                let cakeData = try JSONDecoder().decode([CakeItem].self, from: data)
                
                //Get back to the main queue and update the tableView with cakes
                DispatchQueue.main.async {
                    self.cakes = cakeData
                    self.tableView?.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }

        }.resume()
    }

    func downloadImage(imageUrlString: String, imageView: UIImageView) {
        guard let imageUrl = URL(string: imageUrlString) else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            let cakeImage = UIImage(data: data)
            
            //Get back to the main queue and update the imageView
            DispatchQueue.main.async {
                imageView.image = cakeImage
            }
            
        }.resume()
    }
}
