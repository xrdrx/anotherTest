//
//  APIPicture.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

struct APIPicture: Decodable {
    let url: String
    let text: String
}

extension APIPicture: CustomStringConvertible {
    var description: String {
        return "Provided text: \(text)\nImage URL: \(url)"
    }
}
