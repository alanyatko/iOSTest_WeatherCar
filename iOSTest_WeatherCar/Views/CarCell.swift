//
//  CarCell.swift
//  iOSTest_WeatherCar
//
//  Created by Андрей Дорош on 01.08.17.
//  Copyright © 2017 Андрей Дорош. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Objc

class CarCell: UITableViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLbl: ACFloatingTextField!
    @IBOutlet weak var priceLbl: ACFloatingTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImg.image = UIImage(named: "placeholder")
        nameLbl.text = nil
        priceLbl.text = nil
    }
    
    func setupUI()
    {
        nameLbl.placeholder = "Car".localized
        priceLbl.placeholder = "Price".localized
        tintColor = UIColor.white
    }
    
    func initWithData(car: Car) {
        let photos:[UIImage] = (car.images as? [UIImage])!
        if photos.count > 0
        {
            self.avatarImg.image = photos.first
        }
        nameLbl.text = car.name
        priceLbl.text = String(format: "$%@", (car.price ?? "").isEmpty ? "0" : car.price!)
    }
}
