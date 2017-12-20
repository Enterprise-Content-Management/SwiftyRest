//
//  Utility.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 12/5/16.
//  Copyright © 2016 EMC. All rights reserved.
//

open class Utility {
    
    /**
     Parse date string into NSDate in format of "yyyy-MM-dd'T'hh:mm:ss.SSSxxx"
     - parameter    dateString:String       The raw string of date.
     - parameter    dateFormat:String       The format of date want to be. Default is "yyyy-MM-dd'T'HH:mm:ss.SSSxxx".
     - returns:     NSDate?                 Date parsed for this string.
     */
    open static func parseDate(_ dateString: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateString)
    }
    
    /**
     Get human readable date from JSON format date.
     - parameter    jsonDate:String                 Extracted date string from json response.
     - parameter    dateStyle:NSDateFormatterStyle  Format style for date. Default is LongStyle.
     - parameter    timeStyle:NSDateFormatterStyle  Format style for time. Default is MediumStyle.
     - returns:     String?     A readable string date.
     */
    open static func getReadableDate(
        _ jsonDate: String,
        dateStyle: DateFormatter.Style = .long,
        timeStyle: DateFormatter.Style = .medium
        ) -> String? {
        let result = parseDate(jsonDate)
        if let date = result {
            return getReadableDate(date, dateStyle: dateStyle, timeStyle: timeStyle)
        } else {
            return nil
        }
    }
    
    /**
     Get human readable date from NsDate.
     - parameter    data:NSDate                     NSDate for certain date.
     - parameter    dateStyle:NSDateFormatterStyle  Format style for date. Default is LongStyle.
     - parameter    timeStyle:NSDateFormatterStyle  Format style for time. Default is MediumStyle.
     - returns:     String?     A readable string date.
     */
    open static func getReadableDate(
        _ date: Date,
        dateStyle: DateFormatter.Style = .long,
        timeStyle: DateFormatter.Style = .medium
        ) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: date)
    }
}
