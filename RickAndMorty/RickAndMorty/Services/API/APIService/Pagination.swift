//
//  Pagination.swift
//  iOSCleanArchitecture
//
//  Created by Miguel Ferrer Fornali on 19/11/22.
//

final class Pagination<T> {
    typealias Item = T
    
    fileprivate var items: [Item] = []
    fileprivate(set) var currentPage = 1
    var isLastPage: Bool = true
    
    func setItems(_ items: [Item], and isLastPage: Bool) {
        self.isLastPage = isLastPage
        if currentPage == 1 {
            self.items = items
        } else {
            self.items.append(contentsOf: items)
        }
        if !isLastPage { currentPage += 1 }
    }
    
    func getItems() -> [Item] {
        return items
    }
}
