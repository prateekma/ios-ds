//
//  MessageStack.swift
//  ios-ds
//
//  Created by Prateek Machiraju on 8/23/20.
//

import Foundation

struct MessageStack {
    var items = [String]()
    mutating func push(_ item: String) {
        items.append(item)
    }
    mutating func pop() -> String {
        return items.removeLast()
    }
}
