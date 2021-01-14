//
//  CountryDetailsView.swift
//  MilestoneProject13-15
//
//  Created by Marcos Martinelli on 1/13/21.
//

import UIKit

class CountryDetailsView: UITableViewController {
    
    var country: Country!
    let sections = ["Flag", "Details"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    /* switch technique thanks to: clarknt
     https://github.com/clarknt/100-days-of-swift/blob/master/20-Milestone-Projects13-15/Milestone-Projects13-15/DetailViewController.swift
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case "Flag":
            return 1
        case "Details":
            return 3
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case "Flag":
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlagCell", for: indexPath)
            
            if let flagCell = cell as? FlagCell {
                flagCell.flagImageView.image = UIImage(named: getFlag())
                return flagCell
            }
            cell.textLabel?.text = "No flag found"
            return cell
        case "Details":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Details", for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "World Subregion: \(getSubRegion())"
            case 1:
                cell.textLabel?.text = "Country Name: \(getName())"
            case 2:
                cell.textLabel?.text = "Country Capital: \(getCapital())"
            default:
                cell.textLabel?.text = "Could not get info"
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    func getFlag() -> String {
        return country.alpha2Code
    }
    func getSubRegion() -> String {
        return country.subregion
    }
    func getName() -> String {
        return country.name
    }
    func getCapital() -> String {
        return country.capital
    }
}
