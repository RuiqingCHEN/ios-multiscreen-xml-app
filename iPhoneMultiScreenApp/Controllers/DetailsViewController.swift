//
//  DetailsViewController.swift
//  iPhoneApp
//
//  Created by Ruiqing CHEN on 11/02/2025.
//

import UIKit

class DetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - model data
    var personData : Person!
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var habitatLabel: UILabel!
    @IBOutlet weak var lifespanLabel: UILabel!
    @IBOutlet weak var feedingLabel: UILabel!
    @IBOutlet weak var tsnLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    @IBAction func webInfoAction(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        // Do any additional setup after loading the view.
        nameLabel.text     = personData.name
        introLabel.text    = personData.intro
        habitatLabel.text  = personData.habitat
        lifespanLabel.text = personData.lifespan
        feedingLabel.text  = personData.feeding
        tsnLabel.text      = personData.tsn
        urlLabel.text      = personData.url
        setupCollectionView()
    }
    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personData.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            let imageName = personData.images[indexPath.item]
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
        return cell
    }
    private func setupCollectionView() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        if let layout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            imagesCollectionView.isScrollEnabled = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height - 20, height: collectionView.frame.height - 20)
    }
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue2"{
            // Get the new view controller using segue.destination.
            let destinationController = segue.destination as! WebViewController
            // Pass the selected object to the new view controller.
            destinationController.urlData = self.personData.url
        }
    }
}
