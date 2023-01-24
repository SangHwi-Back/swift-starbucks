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
  
  enum CodingKeys: CodingKey {
    case title
    case name
    case tempOption
  }
  
  enum TemperatureOptions: Decodable {
    case hot
    case cold
  }
  
  // Data from json
  let title: String
  let name: String
  var tempOption: TemperatureOptions = .hot
  
  // no Data from json
  var imageData: Data?
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.title = try container.decode(String.self, forKey: .title)
    self.name = try container.decode(String.self, forKey: .name)
    
    if let tempOptionSeparator = try? container.decode(Int.self, forKey: .tempOption) {
      self.tempOption = tempOptionSeparator == 1 ? .cold : .hot
    }
  }
}
