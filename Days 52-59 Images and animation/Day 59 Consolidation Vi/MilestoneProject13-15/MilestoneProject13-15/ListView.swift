//
//  ViewController.swift
//  MilestoneProject13-15
//
//  Created by Marcos Martinelli on 1/12/21.
//

import UIKit

class ListView: UITableViewController {
    var countries = [Country]()
    var countriesByRegion = [Region]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Loading coutries..."
        
        performSelector(inBackground: #selector(loadData), with: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countriesByRegion.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countriesByRegion[section].subRegion
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countriesInRegion = countriesByRegion[section]
        return countriesInRegion.countries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        
        guard let cell = reusableCell as? CountryCell else {
            return reusableCell
        }
        
        let countriesInRegion = countriesByRegion[indexPath.section].countries
        cell.countryNameLabel.text = countriesInRegion[indexPath.row].name
        cell.flagImageView.image = UIImage(named: countriesInRegion[indexPath.row].alpha2Code)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailsVc = storyboard?.instantiateViewController(identifier: "CountryDetails") as? CountryDetailsView {
            let countriesInRegion = countriesByRegion[indexPath.section].countries
            let country = countriesInRegion[indexPath.row]
            detailsVc.country = country
            
            navigationController?.pushViewController(detailsVc, animated: true)
        }
    }
    // APP FUNCTIONS
    @objc func loadData() {
        let stringURL = "https://restcountries.eu/rest/v2/all?fields=subregion;name;alpha2Code;capital;population;currencies;languages;"
        
        if let url = URL(string: stringURL) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([Country].self, from: data)
                
                countries = decodedData
                
                performSelector(onMainThread: #selector(updateUI), with: nil, waitUntilDone: true)
                
            } catch {
                print(error)
            }
        }
    }
    func sortCountriesByRegion(countries: [Country]) -> [Region] {
        // group within a dictionary String: [Country]
        let groupedByRegion = Dictionary(grouping: countries) { $0.subregion  }
        // transform dictionary into [Region]()
        let groupedIntoRegion = groupedByRegion.map({ (subregion, subCountries) in
            return Region(subRegion: subregion, countries: subCountries)
        })

        return groupedIntoRegion
    }
    @objc func updateUI() {
        // update coutriesByRegion
        countriesByRegion = sortCountriesByRegion(countries: countries)
        // alphabetically sort array by region
        countriesByRegion.sort { (regionA, regionB) -> Bool in
            return regionA.subRegion < regionB.subRegion
        }
        title = "Country Facts"
        tableView.reloadData()
    }
}

