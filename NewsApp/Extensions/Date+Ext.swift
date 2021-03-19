//
//  Date+Ext.swift
//  NewsApp
//
//  Created by finebel on 11.08.20.
//

import Foundation

extension Date {
    func getStringRepresentation() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de")
        dateFormatter.dateFormat = "dd. MMM yyyy - HH:mm"
        
        return dateFormatter.string(from: self) + " Uhr"
    }
}
