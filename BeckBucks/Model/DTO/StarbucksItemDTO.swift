//
//  StarbucksItemDTO.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/27.
//

import Foundation

struct StarbucksArray: Decodable {
  let foods: [StarbucksItemDTO]
}

struct StarbucksItemDTO: Decodable {
  let title: String
  let name: String
    
  var imageData: Data?
}
