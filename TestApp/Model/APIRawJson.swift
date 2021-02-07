//
//  APIRawJson.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

struct APIRawJson: Decodable {
    let data: [APIData]
    let view: [APIDataType]
}
