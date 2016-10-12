//
//  ColorRecord.swift
//  ContactMySensors
//
//  Created by Jack N. Archer on 11/10/2016.
//  Copyright © 2016 Jack N. Archer. All rights reserved.
//

import UIKit

class ColorRecord: NSObject {
    /// Refers to the clear light reading
    var clear:Double!
    
    /// Refers to the red color strength in a RGB color system
    var red:Double!
    
    /// Refers to the green color strength in a RGB color system
    var green:Double!
    
    /// Refers to the blue color strength in a RGB color system
    var blue:Double!
    
    /// Refers to timestamp of the record
    var time:Date!
    
    /// - Parameters:
    ///     - clear: Refers to the clear light reading
    ///     - red: Refers to the red color strength in a RGB color system
    ///     - green: Refers to the green color strength in a RGB color system
    ///     - blue: Refers to the blue color strength in a RGB color system
    ///     - timeInterval: The number of milliseconds since 1970.1.1
    init(clear: Double, red: Double, green: Double, blue: Double, timeInterval:Int) {
        self.clear = clear
        self.red = red
        self.green = green
        self.blue = blue
        time = Date(timeIntervalSince1970: (Double(timeInterval) / 1000.0))
    }
    
    ///This method is used to get a fomatted date time in String.
    ///- Returns: Date & time for the date before today, and only time for today, in the String format.
    func getFormattedTime() -> String{
        let df = DateFormatter()
        let today = Date()
        // within today
        if Calendar.current.compare(today, to: self.time, toGranularity: .day) == ComparisonResult.orderedSame{
            df.dateFormat = "HH:mm:ss.SSSS"
        } else {
            df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        }
        df.timeZone = TimeZone(abbreviation: "AEDT")
        return df.string(from: time)
    }
    
    /// This function is used to get a generated array, which contains all the detail information that will be displayed
    /// on the detail view. The detail view in our design would also be a table view, so it would be better
    /// to store all the information by an array.
    /// - Returns: An array that contains all detail info for the color record.
    func getDetailInArray() -> Array<String>!{
        var result:[String] = []
        result.append("Time: \(getFormattedTime())")
        result.append("Clear: \(clear!)")
        result.append("Red: \(red!)")
        result.append("Green: \(green!)")
        result.append("Blue: \(blue)")
        return result
    }
    
    /// This function is used to generated a String format of the detailed info
    /// Returns: A String that contains all detailed info for the color record in multiple lines
    func getDetailInString() -> String!{
        var result:String = ""
        for str in getDetailInArray(){
            if !result.isEmpty{
                result += "\n"
            }
            result += str
        }
        return result
    }
}
