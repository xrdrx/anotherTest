//
//  APIHz.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

struct APIHz: Decodable {
    let text: String
}

extension APIHz: CustomStringConvertible {
    var description: String {
        return "Provided text: \(text)"
    }
}
