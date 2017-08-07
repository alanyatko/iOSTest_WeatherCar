//
//  String+Helper.swift
//  iOSTest_WeatherCar
//
//  Created by Андрей Дорош on 04.08.17.
//  Copyright © 2017 Андрей Дорош. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
}
