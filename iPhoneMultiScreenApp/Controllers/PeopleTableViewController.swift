//
//  PeopleTableViewController.swift
//  iPhoneApp
//
//  Created by Ruiqing CHEN on 11/02/2025.
//

import UIKit

class PeopleTableViewController: UITableViewController, UISearchBarDelegate {
    // MARK: - outlets and action
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    // MARK: - model data
    var peopleData : People!
    var sections: [(title: String, data: [Person])] = []
    var filteredSections: [(title: String, data: [Person])] = []
    let bgImageNames = ["bg01.jpeg", "bg02.jpeg", "bg03.jpeg"]
    var currentIndex = 0
    var timer: Timer?
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Animals"
        // init model data
        peopleData = People(xmlFile: "members.xml")
        sections = [
            ("Aerial", peopleData.aerial),
            ("Aquatic", peopleData.aquatic),
            ("Terrestrial", peopleData.terrestrial)
        ]
        filteredSections = sections
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        setupPageControl()
        updateImage()
        startAutoScroll()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return filteredSections.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredSections[section].title
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredSections[section].data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // get the cell data from peopleData
        let personData = filteredSections[indexPath.section].data[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = personData.name
        cell.detailTextLabel?.text = personData.tsn
        cell.imageView?.image = UIImage(named: personData.images.first!)
        if let imageView = cell.imageView {
            let size: CGFloat = 50
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.deactivate(imageView.constraints)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: size),
                imageView.heightAnchor.constraint(equalToConstant: size),
                imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 15),
            ])
            imageView.layer.cornerRadius = size / 2
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
        }
        if let textLabel = cell.textLabel {
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textLabel.leadingAnchor.constraint(equalTo: cell.imageView!.trailingAnchor, constant: 15),
                textLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
            ])
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    // MARK: - UISearchBarDelegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if searchText.isEmpty {
            filteredSections = sections
        } else {
            filteredSections = sections.map { section in
                let filteredData = section.data.filter {
                    $0.name.lowercased().contains(searchText.lowercased())
                }
                return (title: section.title, data: filteredData)
            }.filter { !$0.data.isEmpty }
        }
        tableView.reloadData()
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredSections = sections
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    // MARK: - UIPageControl
    func setupPageControl() {
        pageControl.numberOfPages = bgImageNames.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
    }
    func updateImage() {
        UIView.transition(with: bgImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.bgImageView.image = UIImage(named: self.bgImageNames[self.currentIndex])
                }, completion: nil)
        pageControl.currentPage = currentIndex
    }
    @objc func pageControlTapped() {
        currentIndex = pageControl.currentPage
        updateImage()
        resetTimer()
    }
    func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[weak self] _ in
            guard let self = self else { return }
            self.currentIndex = (self.currentIndex + 1) % self.bgImageNames.count
            self.updateImage()
            
        }
    }
    func resetTimer() {
        timer?.invalidate()
        startAutoScroll()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue0" {
            let destinationController = segue.destination as! PersonViewController
            // Get the new view controller using segue.destination.
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            // Pass the selected object to the new view controller.
            destinationController.peopleData = peopleData
            let selectedPerson = filteredSections[indexPath!.section].data[indexPath!.row]
            if let originalIndex = peopleData.people.firstIndex(where: { $0.name == selectedPerson.name }) {
                destinationController.index = originalIndex
            }
        }
    }
}

