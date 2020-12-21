//
//  ViewController.swift
//  Project7
//
//  Created by Marcos Martinelli on 12/15/20.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitionList = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
                 
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Source", style: .plain, target: self, action: #selector(showSource))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(getUserInput))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        performSelector(inBackground: #selector(fetchJSON), with: urlString)
    }
    @objc func fetchJSON(urlString: String) {
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitionList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitionList[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitionList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitionList += petitions
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func showSource() {
        let ac = UIAlertController(title: "Data Source", message: "The data is sourced from We the People API provided by the White House.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
        present(ac, animated: true)
    }
    @objc func getUserInput() {
        let ac = UIAlertController(title: "Search", message: "What are you looking for?", preferredStyle: .alert)
        ac.addTextField()
        
        let searchAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            if let userInput = ac?.textFields?[0].text {
                self?.filterRestuls(userInput.lowercased())
            }
        }
        
        ac.addAction(searchAction)
        ac.addAction(UIAlertAction(title: "Reload", style: .default, handler: reloadPetitions))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        
        present(ac, animated: true)
    }
    func filterRestuls(_ userInput: String) {
        
        var result = [Petition]()
        
        for petition in filteredPetitionList {
            let currentPetition = petition.title.lowercased() + " " + petition.body.lowercased()
    
            if currentPetition.contains(userInput) {
                result.append(petition)
            }
        }
        filteredPetitionList.removeAll(keepingCapacity: true)
        filteredPetitionList += result
        title = "Viewing \(filteredPetitionList.count) petitions"
        reloadTitle()
        tableView.reloadData()
    }
    func reloadPetitions(action: UIAlertAction! = nil){
        filteredPetitionList.removeAll(keepingCapacity: true)
        filteredPetitionList = petitions
        reloadTitle()
        tableView.reloadData()
    }
    @objc func reloadTitle() {
        title = "Viewing \(filteredPetitionList.count) petitions"
    }
}

