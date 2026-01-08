//
//  PersonViewController.swift
//  iPhoneApp
//
//  Created by Ruiqing CHEN on 11/02/2025.
//

import UIKit

class PersonViewController:
    UIViewController,
    UIPickerViewDelegate,
    UIPickerViewDataSource{
    //MARK: - model data
    var personData : Person!
    var peopleData : People!
    var index = 0
    var imageIndex = 0
    //MARK: - picker protocol methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return peopleData.count()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return peopleData.person(index: row).name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // change personData
        personData = peopleData.person(index: row)
        imageIndex = 0
        // updata the interface
        personLabel.text = personData.name
        introLabel.text = personData.intro
        
        personImageView.image = UIImage(named: personData.images[imageIndex])
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = peopleData.person(index: row).name
        label.textAlignment = .center
        label.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return label
    }

    //MARK: -Outlets
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var personPicker: UIPickerView!
    @IBOutlet weak var introLabel: UILabel!
    @IBAction func nextImageAction(_ sender: Any) {
        imageIndex += 1;
        if imageIndex ==  personData.images.count {
            imageIndex = 0
        }
        personImageView.image = UIImage(named: personData.images[imageIndex])
    }
    @IBAction func previousImageAction(_ sender: Any) {
        imageIndex -= 1;
        if imageIndex == -1 {
            imageIndex = personData.images.count - 1
        }
        personImageView.image = UIImage(named: personData.images[imageIndex])
    }
    @IBAction func moreInfoAction(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the title
        title = "Animal"
        // get the data
        personData = peopleData.person(index: index)
        // populate the outlets with data
        personLabel.text = personData.name
        introLabel.text  = personData.intro
        personImageView.image = UIImage(named: personData.images[imageIndex])
        // setup the protocols for the picker
        personPicker.delegate = self
        personPicker.dataSource = self
        // pick the index line
        personPicker.selectRow(index, inComponent: 0, animated: false)
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1"{
            // Get the new view controller using segue.destination.
            let destinationController = segue.destination as! DetailsViewController
            // Pass the selected object to the new view controller.
            destinationController.personData = self.personData
        }
    }
}
