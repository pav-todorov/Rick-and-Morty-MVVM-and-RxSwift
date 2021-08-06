//
//  CharactersTableViewController.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel Todorov on 4.08.21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CharactersTableViewController: UITableViewController {
    
    var toAppendCharacter:[Character] = []
    
    private let disposeBag = DisposeBag()
    var episodeViewModel = BehaviorRelay<EpisodeViewModel?>(value: nil)
    var receivedEpisode = BehaviorRelay<EpisodeViewModel?>(value: nil)
//    var singleCharacterViewModel = SingleCharacterViewModel(character: Character(name: "", status: "", species: "", gender: "", image: ""))
    
//    var charactersListViewModel = BehaviorRelay<CharactersListViewModel?>(value: nil)
    
    var charactersListViewModel: CharactersListViewModel?
    
    var characterObject = PublishSubject<[Character]>()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = nil
        
        receivedEpisode.subscribe(onNext: {
            episode in
            
            self.episodeViewModel.accept(episode)
            
         
        }).disposed(by: disposeBag)
        
        
        // MARK: - Table view data source
        
//        var characters = charactersListViewModel?.getAllCharacters()
        
        
        
        characterObject.bind(to: tableView.rx.items(cellIdentifier: "CharacterTableViewCell")) { index, model, cell in

            cell.textLabel?.text = model.name


        }.disposed(by: disposeBag)
            
        populateCharacters()

      
        self.characterObject.onNext(toAppendCharacter)
        

    }
    
    
    private func populateCharacters() {
        
        
            
        receivedEpisode.subscribe(onNext: { episodeViewModel in
            
            if let episodeViewModel = episodeViewModel{
                
                let array = episodeViewModel.episodeCharacters
                
                array.subscribe(onNext: { linksArray in
                    linksArray.compactMap { charactersLink in
                        
                        let resource = Resource<Character>(url: URL(string: charactersLink)!)
                        
                        URLRequest.load(resource: resource)
                            .subscribe(onNext: { [self] character in
                                
                                          
                                toAppendCharacter.append(character)

                                print("characters inside closure 1", character)
                                
                                print("inside closure 1", toAppendCharacter.count)
                                
                            }).disposed(by: self.disposeBag)
                        print("inside closure 2", self.toAppendCharacter.count)
                    }
                    print("inside closure 3", self.toAppendCharacter.count)
                }).disposed(by: self.disposeBag)
                print("inside closure 4", self.toAppendCharacter.count)
            }
            print("inside closure 5", self.toAppendCharacter.count)
        }).disposed(by: disposeBag)
        
        self.characterObject.onNext(toAppendCharacter)
        
        print("outside closure", toAppendCharacter.count)
        
        
        
    }
    
}
