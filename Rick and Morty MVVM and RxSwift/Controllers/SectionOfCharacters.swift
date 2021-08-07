////
////  SectionOfCharacters.swift
////  Rick and Morty MVVM and RxSwift
////
////  Created by Pavel on 7.08.21.
////
//
//import Foundation
//import RxDataSources
//
//struct SectionOfCharacters: AnimatableSectionModelType, Equatable {
//    static func == (lhs: SectionOfCharacters, rhs: SectionOfCharacters) -> Bool {
//        lhs.uniqueId > rhs.uniqueId
//    }
//    
//    var uniqueId: Int
//    var header: String
//    var items: [Item]
//    
//    typealias Item = Character
//    
//    init(original: SectionOfCharacters, items: [Item]) {
//      self = original
//      self.items = items
//    }
//    
//    typealias Identity = Int
//    var identity: Int {
//      return uniqueId //Use this
//    }
//
//}
