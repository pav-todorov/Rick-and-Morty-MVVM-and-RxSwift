//
//  EpisodeList.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel Todorov on 3.08.21.
//

import Foundation

struct PageInfo: Codable {
    let pages: Int
}

struct EpisodeList: Codable {
    let results: [Episode]
}

struct Episode: Codable {
    let name: String
    let episode: String
    let characters: [String]
}
