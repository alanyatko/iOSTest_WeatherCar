//
//  CarListVC.swift
//  iOSTest_WeatherCar
//
//  Created by Андрей Дорош on 01.08.17.
//  Copyright © 2017 Андрей Дорош. All rights reserved.
//

import UIKit
import CoreData
import MXParallaxHeader

class CarListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var carsTbl: UITableView!
    
    var cars: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Car")
        
        do {
            cars = try managedContext.fetch(fetchRequest)
            carsTbl.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back".localized
        navigationItem.backBarButtonItem = backItem
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 155/255.0, green: 200/255.0, blue: 74/255.0, alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor(red: 155/255.0, green: 200/255.0, blue: 74/255.0, alpha: 1.0)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .white)
        
        title = "Car list".localized
        carsTbl.tableFooterView = UIView()
        
        let weatherVC = WeatherVC.init()
        addChildViewController(weatherVC)
        carsTbl.parallaxHeader.view = weatherVC.view
        carsTbl.parallaxHeader.height = 200
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CarCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CarCell.self)) as! CarCell!
        let car = cars[indexPath.row] as! Car
        cell.initWithData(car: car)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: CarDetailTVC = storyboard?.instantiateViewController(withIdentifier: String(describing: CarDetailTVC.self)) as! CarDetailTVC
        let car = cars[indexPath.row] as! Car
        vc.car = car
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let car = cars[indexPath.row]

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            managedContext.delete(car)
            
            do {
                try managedContext.save()
                cars.remove(at: indexPath.row)
                carsTbl.reloadData()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
