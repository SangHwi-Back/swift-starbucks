import Foundation

struct HomeMainDTO: Decodable {
    let mainHeaderImageFileName: String
    let mainEventImageFileName: String
    var processingEventImageFileNames: [String]
    var whatsNewList: [WhatsNewDTO]
}

struct WhatsNewDTO: Decodable {
    let title: String
    let subTitle: String
    let imageFileName: String
    let detailImageFileName: String
}
