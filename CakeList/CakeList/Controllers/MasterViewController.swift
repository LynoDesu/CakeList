//
//  MasterViewController.swift
//  CakeList
//
//  Created by Adam Bandeira Lynas on 15/04/2019.
//  Copyright © 2019 Limit Break Technology Ltd. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects = [CakeItem]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        objects.append(CakeItem(cakeTitle: "Item 1", cakeDescription: "This is a cake....", cakeImageUrl: nil))
        objects.append(CakeItem(cakeTitle: "Item 2", cakeDescription: "This is a cake....", cakeImageUrl: nil))
        objects.append(CakeItem(cakeTitle: "Item 2", cakeDescription: "This is a cake....", cakeImageUrl: nil))
        objects.append(CakeItem(cakeTitle: "Item 2", cakeDescription: "This is a cake....", cakeImageUrl: nil))
        objects.append(CakeItem(cakeTitle: "Item 2", cakeDescription: "This is a cake....", cakeImageUrl: nil))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CakeCell", for: indexPath) as! CakeCell

        let cake = objects[indexPath.row]
        cell.titleLabel.text = cake.cakeTitle
        cell.descriptionLabel.text = cake.cakeDescription
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

