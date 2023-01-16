//
//  String+Extension.swift
//  RickAndMorty
//
//  Created by Miguel Ferrer Fornali on 17/1/23.
//

import Foundation

extension String {
    func substring(ofLast last: Int) -> String? {
        return substring(self.count - last)
    }
    
    func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else {
            return nil
        }
        return String(self[range])
    }
    
    func substring(_ beginIndex: Int) -> String? {
        return substring(with: NSRange(location: beginIndex, length: self.count - beginIndex))
    }
    
    func toDate(dateFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)
    }
}
