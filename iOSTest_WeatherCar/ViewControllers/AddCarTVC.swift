//
//  AddCarTVC.swift
//  iOSTest_WeatherCar
//
//  Created by Андрей Дорош on 04.08.17.
//  Copyright © 2017 Андрей Дорош. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Objc
import CoreData

class AddCarTVC: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameFld: ACFloatingTextField!
    @IBOutlet weak var priceFld: ACFloatingTextField!
    @IBOutlet weak var engineTitleLbl: UILabel!
    @IBOutlet weak var transmissionTitleLbl: UILabel!
    @IBOutlet weak var conditionTitleLbl: UILabel!
    @IBOutlet weak var engineFld: UITextField!
    @IBOutlet weak var transmissionFld: UITextField!
    @IBOutlet weak var conditionFld: UITextField!
    @IBOutlet weak var descTitleLbl: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var toolbarView: UIToolbar!
    
    var photos: [UIImage] = [UIImage]()
    
    var engineData: [String] = [String]()
    var transmissionData: [String] = [String]()
    var conditionData: [String] = [String]()
    var pickerData: [String] = [String]()
    
    var selTextFld: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add car".localized, style: .plain, target: self, action: #selector(addCarAction))
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        nameFld.placeholder = "Car".localized
        priceFld.placeholder = "Price".localized
        engineTitleLbl.text = "Engine".localized
        transmissionTitleLbl.text = "Transmission".localized
        conditionTitleLbl.text = "Condition".localized
        descTitleLbl.text = "Description".localized
        
        priceFld.inputAccessoryView = toolbarView
        
        engineFld.inputView = pickerView
        engineFld.inputAccessoryView = toolbarView
        
        transmissionFld.inputView = pickerView
        transmissionFld.inputAccessoryView = toolbarView
        
        conditionFld.inputView = pickerView
        conditionFld.inputAccessoryView = toolbarView
        
        descTextView.textContainer.lineFragmentPadding = 0
        descTextView.textContainerInset = UIEdgeInsets.zero
    }
    
    func setupData() {
        
        engineData = [
            "1.5i.e".localized,
            "2.0i.e".localized,
            "2.5i.e".localized,
            "3.0i.e".localized,
            "2.0d.e".localized,
            "2.5d.e".localized
        ]
        
        transmissionData = [
            "Manual".localized,
            "Automate".localized,
            "Tiptronic".localized
        ]
        
        conditionData = [
            "Bad".localized,
            "Good".localized,
            "Excellent".localized
        ]
        
        engineFld.text = engineData.first
        transmissionFld.text = transmissionData.first
        conditionFld.text = conditionData.last
    }

    func addCarAction(sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Car", in: managedContext)!
        
        let car = NSManagedObject(entity: entity, insertInto: managedContext)
        
        car.setValue(photos, forKey: "images")
        car.setValue(nameFld.text, forKeyPath: "name")
        car.setValue(priceFld.text, forKeyPath: "price")
        car.setValue(engineFld.text, forKeyPath: "engine")
        car.setValue(transmissionFld.text, forKeyPath: "transmission")
        car.setValue(conditionFld.text, forKeyPath: "condition")
        car.setValue(descTextView.text, forKeyPath: "desc")
        
        do {
            try managedContext.save()
            navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func prevAction(_ sender: Any) {
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
    }
    
    @IBAction func closePickerAction(_ sender: Any) {
        selTextFld?.resignFirstResponder()
        selTextFld = nil
    }
    
    // MARK: - UITextfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selTextFld = textField
        if textField == engineFld
        {
            pickerData = engineData
        }
        else if textField == transmissionFld
        {
            pickerData = transmissionData
        }
        else if textField == conditionFld
        {
            pickerData = conditionData
            
        }
        if textField == engineFld || textField == transmissionFld || textField == conditionFld
        {
            pickerView.reloadAllComponents()
            pickerView.selectRow(pickerData.index(of: textField.text!)!, inComponent: 0, animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == engineFld || textField == transmissionFld || textField == conditionFld
        {
            return false
        }
        return true
    }
    
    // MARK: - UITextView
    
    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
    
    // MARK: - UIImagePickerController
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        photos.append(image)
        collectionView.reloadData()
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selTextFld?.text = pickerData[row]
    }

    // MARK: - UITableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else if section == 1
        {
            return 2
        }
        else if section == 2
        {
            return 3
        }
        else
        {
            return 1
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            return photos.count
        }
        else
        {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0
        {
            let cell:CarPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CarPhotoCell.self), for: indexPath) as! CarPhotoCell
            cell.photoImg.image = photos[indexPath.item]
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarAddPhotoCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1
        {
            let camera = DSCameraHandler(delegate_: self)
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            optionMenu.popoverPresentationController?.sourceView = self.view
            
            let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
                camera.getCameraOn(self, canEdit: true)
            }
            let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
                camera.getPhotoLibraryOn(self, canEdit: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
            }
            optionMenu.addAction(takePhoto)
            optionMenu.addAction(sharePhoto)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
