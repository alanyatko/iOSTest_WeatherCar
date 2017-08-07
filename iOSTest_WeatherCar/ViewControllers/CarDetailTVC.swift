//
//  CarDetailTVC.swift
//  iOSTest_WeatherCar
//
//  Created by Андрей Дорош on 05.08.17.
//  Copyright © 2017 Андрей Дорош. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Objc

class CarDetailTVC: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameTitleLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceTitleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var engineTitleLbl: UILabel!
    @IBOutlet weak var transmissionTitleLbl: UILabel!
    @IBOutlet weak var conditionTitleLbl: UILabel!
    @IBOutlet weak var engineLbl: UILabel!
    @IBOutlet weak var transmissionLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var descTitleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    var car: Car!
    var photos: [UIImage] = [UIImage]()

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
        title = "Title"
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        nameTitleLbl.text = "Car".localized
        priceTitleLbl.text = "Price".localized
        
        engineTitleLbl.text = "Engine".localized
        transmissionTitleLbl.text = "Transmission".localized
        conditionTitleLbl.text = "Condition".localized
        descTitleLbl.text = "Description".localized
    }
    
    func setupData() {
        nameLbl.text = car.name
        priceLbl.text = String(format: "$%@", (car.price ?? "").isEmpty ? "0" : car.price!)
        engineLbl.text = car.engine
        transmissionLbl.text = car.transmission
        conditionLbl.text = car.condition
        descLbl.text = car.desc
        
        photos = (car.images as? [UIImage])!
        pageControl.numberOfPages = photos.count
        collectionView.reloadData()
    }
    
    // MARK: - UIPageControl
    
    @IBAction func pageControlValueChangeAction(_ sender: Any) {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0) as IndexPath
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }

    // MARK: - UITableView data source

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
            return 1
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return max(1, photos.count)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CarPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CarPhotoCell.self), for: indexPath) as! CarPhotoCell
        if (indexPath.item <= photos.count - 1)
        {
            cell.photoImg.image = photos[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
