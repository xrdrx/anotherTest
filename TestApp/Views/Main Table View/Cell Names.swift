//
//  Cell Names.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

enum CellNames {
    
    static func getNibName(for type: APIDataType) -> String {
        switch type {
        case .hz:
            return "HzTableViewCell"
        case .picture:
            return "PictureTableViewCell"
        case .selector:
            return "SelectorTableViewCell"
        }
    }
    
    static func getReuseId(for type: APIDataType) -> String {
        switch type {
        case .hz:
            return "HzCell"
        case .picture:
            return "PictureCell"
        case .selector:
            return "SelectorCell"
        }
    }
    
}
