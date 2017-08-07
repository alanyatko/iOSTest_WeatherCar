//
//  WeatherVC.swift
//  iOSTest_WeatherCar
//
//  Created by Андрей Дорош on 05.08.17.
//  Copyright © 2017 Андрей Дорош. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire
import AlamofireImage

class WeatherVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    
    var locationManager: CLLocationManager!
    
    var weather: Weather?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.alpha = 0
        
        setupData()

        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 100.0;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Weather")
        
        do {
            weather = try managedContext.fetch(fetchRequest).last as? Weather
            if weather != nil
            {
                tempLbl.text = String(format: "%@%d", Int((weather?.temp)!) > 0 ? "+" : "", Int((weather?.temp)!))
                weatherIcon.af_setImage(withURL: NSURL(string: (weather?.icon)!)! as URL)
                descLbl.text = weather?.desc
                cityLbl.text = weather?.city
                UIView.animate(withDuration: 1.0, animations: {
                    self.contentView.alpha = 1
                }, completion: {
                    (value: Bool) in
                })
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func loadWeather(location: CLLocation) {
        
        let locValue:CLLocationCoordinate2D = location.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?lat=\(locValue.latitude)&lon=\(locValue.longitude)&units=metric&appid=4e832cd2b85ade2c738fefecb5924e44"
        Alamofire.request(urlStr).responseJSON { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                print("JSON: \(json)")
                self.saveWeather(data: json as! [String : Any])
            }
        }
    }
    
    func saveWeather(data: [String:Any]) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: managedContext)!
        
        if weather == nil {
            weather = NSManagedObject(entity: entity, insertInto: managedContext) as? Weather
        }
        
        weather?.setValue(data["name"], forKeyPath: "city")
        if let coord = data["coord"] as? NSDictionary {
            weather?.setValue(coord["lat"], forKeyPath: "lat")
            weather?.setValue(coord["lon"], forKeyPath: "lng")
        }
        if let main = data["main"] as? NSDictionary {
            weather?.setValue(main["temp"], forKeyPath: "temp")
        }
        if let weatherArray = data["weather"] as? NSArray {
            if let weatherDict = weatherArray.firstObject as? NSDictionary {
                weather?.setValue(weatherDict["description"], forKeyPath: "desc")
                let str = String(format: "http://openweathermap.org/img/w/%@.png", weatherDict.value(forKey: "icon") as! CVarArg)
                print("\(str)")
                weather?.setValue(String(format: "http://openweathermap.org/img/w/%@.png", weatherDict.value(forKey: "icon") as! CVarArg), forKeyPath: "icon")
            }
        }
        
        tempLbl.text = String(format: "%@%d", Int((weather?.temp)!) > 0 ? "+" : "", Int((weather?.temp)!))
        weatherIcon.af_setImage(withURL: NSURL(string: (weather?.icon)!)! as URL)
        descLbl.text = weather?.desc
        cityLbl.text = weather?.city
        UIView.animate(withDuration: 1.0, animations: {
            self.contentView.alpha = 1
        }, completion: {
            (value: Bool) in
        })
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - CLLocationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        loadWeather(location:  manager.location!)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(manager.location!, completionHandler: {
            placemarks, error in
            
            if let err = error
            {
                print("\(err.localizedDescription)")
            }
            else if let placemarkArray = placemarks
            {
                if let placemark = placemarkArray.first
                {
                    print("\(placemark)")
                }
                else
                {
                    
                }
            }
            else
            {
                
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error = \(error.localizedDescription)")
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
