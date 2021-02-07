//
//  JsonDecodingTests.swift
//  TestAppTests
//
//  Created by Aleksandr Svetilov on 06.02.2021.
//

import XCTest
@testable import TestApp

class JsonDecodingTests: XCTestCase {
    
    let rawJson = """
    {
      "data": [
        {
          "name": "hz",
          "data": {
            "text": "Текстовый блок"
          }
        },
        {
          "name": "picture",
          "data": {
            "url": "https://pryaniky.com/static/img/logo-a-512.png",
            "text": "Пряники"
          }
        },
        {
          "name": "selector",
          "data": {
            "selectedId": 1,
            "variants": [
              {
                "id": 1,
                "text": "Вариант раз"
              },
              {
                "id": 2,
                "text": "Вариант два"
              },
              {
                "id": 3,
                "text": "Вариант три"
              }
            ]
          }
        }
      ],
      "view": [
        "hz",
        "selector",
        "picture",
        "hz"
      ]
    }
    """
    let decoder = JSONDecoder()

    func testJsonCanBeDecoded() {
        XCTAssertNoThrow(try decoder.decode(APIRawJson.self, from: Data(rawJson.utf8)))
    }
    
    func testDataHasCorrectViewOrder() {
        let viewOrder: [APIDataType] = [.hz, .selector, .picture, .hz]
        let decoded = try! decoder.decode(APIRawJson.self, from: Data(rawJson.utf8)).view
        XCTAssertEqual(viewOrder, decoded)
    }
    
    func testCorrectNumberOfDataItems() {
        let decoded = try! decoder.decode(APIRawJson.self, from: Data(rawJson.utf8))
        XCTAssertEqual(decoded.data.count, 3)
    }
    
    func testPictureItemDecodes() {
        let decoded = try! decoder.decode(APIRawJson.self, from: Data(rawJson.utf8))
        let picture = (decoded.data)[1].data as? APIPicture
        XCTAssertNotNil(picture)
    }
    
    func testHzItemDecodes() {
        let decoded = try! decoder.decode(APIRawJson.self, from: Data(rawJson.utf8))
        let picture = (decoded.data)[0].data as? APIHz
        XCTAssertNotNil(picture)
    }
    
    func testSelectorItemDecodes() {
        let decoded = try! decoder.decode(APIRawJson.self, from: Data(rawJson.utf8))
        let picture = (decoded.data)[2].data as? APISelector
        XCTAssertNotNil(picture)
    }
    
    func testIncorrectItemDecodingFails() {
        let decoded = try! decoder.decode(APIRawJson.self, from: Data(rawJson.utf8))
        let picture = (decoded.data)[1].data as? APISelector
        XCTAssertNil(picture)
    }
}
