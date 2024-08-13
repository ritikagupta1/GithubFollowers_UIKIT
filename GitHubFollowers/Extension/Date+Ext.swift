//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Ritika Gupta on 01/08/24.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
