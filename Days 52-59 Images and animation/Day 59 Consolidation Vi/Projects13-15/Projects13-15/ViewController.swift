//
//  ViewController.swift
//  Projects13-15
//
//  Created by Marcos Martinelli on 1/9/21.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    var regions = [String]()
    var countriesByRegion = [Region]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Loading Countries..."
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getCountries()
    }
    // Table Data
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countriesByRegion.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numOfCountries = countriesByRegion[section]
        return numOfCountries.countries.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = countriesByRegion[section].region
        return title
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let region = countriesByRegion[indexPath.section]
        let country = region.countries[indexPath.row]
        
        cell.textLabel?.text = country.name
        
        return cell
    }
    // Custom Functions
    func getCountries() {
        let urlString = "https://restcountries.eu/rest/v2/all"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                }
                if let unwrappedData = data {
                    self.countries = self.parseCountries(unwrappedData)
                    
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                    
                }
            }
            task.resume()
        }
    }
    func parseCountries(_ jsonData: Data) -> [Country] {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([Country].self, from: jsonData)
            return decodedData
        } catch {
            print(error)
        }
        return [Country]()
    }
    func sortByRegions() {
        // https://www.hackingwithswift.com/example-code/language/how-to-group-arrays-using-dictionaries\
        // https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/grouping-sections/
        let groupedCountries = Dictionary(grouping: countries) { $0.region  }
        
        countriesByRegion = groupedCountries.map { (region, countries) in
            return Region(region: region, countries: countries)
        }
        countriesByRegion.sort { (a, b) -> Bool in
            return a.region! < b.region!
        }
    }
    func updateUI() {
        sortByRegions()
        title = "Country Facts"
        tableView.reloadData()
    }
}

