//
//  APIData.swift
//  TestApp
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

struct APIData: Decodable {
    let name: APIDataType
    let data: Any
    
    enum CodingKeys: String, CodingKey {
        case name
        case data
      }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(APIDataType.self, forKey: .name)
        switch self.name {
        case .hz:
            self.data = try values.decode(APIHz.self, forKey: .data)
        case .picture:
            self.data = try values.decode(APIPicture.self, forKey: .data)
        case .selector:
            self.data = try values.decode(APISelector.self, forKey: .data)
        }
    }
}
