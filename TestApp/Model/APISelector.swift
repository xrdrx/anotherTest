//
//  APISelector.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

struct APISelector: Decodable {
    let selectedId: Int
    let variants: [APISelectrorVariant]
}

struct APISelectrorVariant: Decodable {
    let id: Int
    let text: String
}

extension APISelectrorVariant: CustomStringConvertible {
    var description: String {
        return "Provided text: \(text)\nId: \(id)"
    }
}
