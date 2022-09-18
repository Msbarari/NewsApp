// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newsDataResponse = try? newJSONDecoder().decode(NewsDataResponse.self, from: jsonData)

import Foundation

// MARK: - NewsDataResponse
struct NewsDataResponse: Codable {
    let status: String?
    let totalResults: Int?
    let results: [NewsDataResponseResult]
    let nextPage: Int?
}

// MARK: - NewsDataResponseResult
struct NewsDataResponseResult: Codable {
    let title: String?
    let link: String?
    let keywords, creator: [String]?
    let videoURL: JSONNull?
    let resultDescription, content: String?
    let pubDate: String?
    let imageURL: String?
    let sourceID: String?
    let country: [String]?
    let category: [String]?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case title, link, keywords, creator
        case videoURL = "video_url"
        case resultDescription = "description"
        case content, pubDate
        case imageURL = "image_url"
        case sourceID = "source_id"
        case country, category, language
    }
}

