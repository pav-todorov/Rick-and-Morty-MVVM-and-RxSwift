//
//  CharactersViewModel.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel Todorov on 5.08.21.
//

import Foundation
import RxSwift
import RxCocoa

class CharactersListViewModel {
    private var characterViewModels = [SingleCharacterViewModel]()
    
    func addCharacterViewModel(_ vm: SingleCharacterViewModel) {
        characterViewModels.append(vm)
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return characterViewModels.count
    }
    
    func modelAt(_ index: Int) -> SingleCharacterViewModel {
        return characterViewModels[index]
    }
    
}

class SingleCharacterViewModel {
    let singleCharacter: Character
    
    init(character: Character) {
        self.singleCharacter = character
    }
    
    var name: Observable<String> {
        return Observable<String>.just(singleCharacter.name)
    }
    
    var status: Observable<String> {
        return Observable<String>.just(singleCharacter.status)
    }
    
    var species: Observable<String> {
        return Observable<String>.just(singleCharacter.species)
    }
    
    var gender: Observable<String> {
        return Observable<String>.just(singleCharacter.gender)
    }
    
    var imageURL: Observable<String> {
        return Observable<String>.just(singleCharacter.image)
    }
    
}
