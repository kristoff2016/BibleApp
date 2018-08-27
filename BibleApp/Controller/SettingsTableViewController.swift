//
//  SettingsTableViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/23/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .grouped)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SettingsColorTableViewCell.self, forCellReuseIdentifier: "color")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Test"
    }
    
    var heightOfColorRow: CGFloat = 0
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            return heightOfColorRow
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "color", for: indexPath) as! SettingsColorTableViewCell
            cell.selectionStyle = .none
            cell.containerView.isHidden = true
            cell.sendColor = { (color) -> () in
                guard let color = color else {return}
                self.receivedColor(color: color)
            }
            return cell
            
        } else if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Set Main Accent Color"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
        
    }
    
    func receivedColor(color: UIColor) {
        let defaults = UserDefaults.standard
        defaults.set(color, forKey: "MainColor")
        tabBarController?.tabBar.tintColor = color
//        defaults.set(color, forKey: "MainColor")
//
//        let newColor = defaults.object(forKey: "MainColor") as! UIColor
//        print("New Color is \(newColor)")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            heightOfColorRow = 60
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            let index = IndexPath(row: 1, section: 0)
            let cell = tableView.cellForRow(at: index) as! SettingsColorTableViewCell
            cell.containerView.isHidden = false
        default:
            return
        }
    }

}
