//
//  WebWeather.swift
//  ContactMySensors
//
//  Created by Jack N. Archer on 13/10/2016.
//  Copyright © 2016 Jack N. Archer. All rights reserved.
//

import UIKit

class WebWeather: NSObject{

    var temperature:Float! = 0
    var airPressure:Float! = 0

    init(temperature:Float!, airPressure:Float!) {
        self.temperature = temperature
        self.airPressure = airPressure
    }
    
    func getDetailInString() -> String!{
        return
            "Current temperature: \(temperature!) °C \n" +
            "Current air pressure: \(airPressure!) kPa"
    }

}
