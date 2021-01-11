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
    var countriesByRegion = [String: [Country]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Coutry Facts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // make this run in the background
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
                        for country in self.countries {
                            if !self.regions.contains(country.region) {
                                self.regions.append(country.region)
                            }
                        }
                        
                        self.tableView.reloadData()
                    }
                    
                }
            }
            task.resume()
        }
        // end background
    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return regions.count
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let title = regions[section]
//        return title
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        
        cell.textLabel?.text = countries[indexPath.row].name
        return cell
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
}

