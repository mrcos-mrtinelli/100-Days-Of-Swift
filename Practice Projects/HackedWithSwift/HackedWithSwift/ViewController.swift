//
//  ViewController.swift
//  HackedWithSwift
//
//  Created by Marcos Martinelli on 12/19/20.
//

import UIKit

class ViewController: UITableViewController {
    
    var curriculum = [CurriculumSections]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hacked With Swift"
        navigationItem.backButtonTitle = "Curriculum"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getLearningResources()
    }
    // tableView Setup
    override func numberOfSections(in tableView: UITableView) -> Int {
        return curriculum.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curriculum[section].learningDays.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = curriculum[section].title
        return title
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = curriculum[indexPath.section].learningDays[indexPath.row].title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LessonViewController()
        guard let url = curriculum[indexPath.section].learningDays[indexPath.row].url else { return }
        vc.urlString = url
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Functions
    func getLearningResources() {
        guard let filePath = Bundle.main.url(forResource: "100DaysOfSwift", withExtension: "txt") else {return}
        if let contentsOfFile = try? String(contentsOf: filePath) {
            let contentsArray = contentsOfFile.components(separatedBy: "\n")
            loadLearningResources(contents: contentsArray)
        }
    }
    func loadLearningResources(contents: [String]) {
        let allSections = contents.split(separator: "")
        
        for section in allSections {
            var learningSection = CurriculumSections()
            
            for el in section {
                if el.hasPrefix("https://") {
                    let parts = el.components(separatedBy: ": ")
                    let day = SectionDays(title: parts[1], url: parts[0])
                    learningSection.learningDays.append(day)
                } else {
                    learningSection.title = el
                }
            }
            curriculum.append(learningSection)
        }
    }
    
}

