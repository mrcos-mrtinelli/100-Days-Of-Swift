//
//  ViewController.swift
//  ShoppingList
//
//  Created by Marcos Martinelli on 12/11/20.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearListButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForItem))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        title = "Your Grocery List"
        
        // set tag to use in shareButtonTapped()
        shareButton.tag = 1
        
        navigationItem.leftBarButtonItem = clearListButton
        navigationItem.rightBarButtonItem = addItemButton
        toolbarItems = [flexSpace, shareButton]
        
        navigationController?.isToolbarHidden = false
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func promptForItem() {
        let ac = UIAlertController(title: "What do you want to add?", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            
            [weak self, weak ac] _ in
            guard let newItem = ac?.textFields?[0].text else { return }
            self?.shoppingList.insert(newItem, at: 0)
            
            // insert item into table
            let index = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [index], with: .automatic)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    @objc func clearList() {
        shoppingList = []
        tableView.reloadData()
    }
    @objc func shareButtonTapped() {
        let listToShare = shoppingList.joined(separator: "\n")
        let activityController = UIActivityViewController(activityItems: [listToShare], applicationActivities: nil)
        guard let buttons = toolbarItems else { return }
        var shareButton: UIBarButtonItem?
        
        for button in buttons {
            if button.tag == 0 {
                shareButton = button
            }
        }
        
        activityController.popoverPresentationController?.barButtonItem = shareButton
        
        present(activityController, animated: true)
    }
}

