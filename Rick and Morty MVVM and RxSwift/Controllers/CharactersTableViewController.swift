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
    
    private let disposeBag = DisposeBag()
    var episodeViewModel = BehaviorRelay<EpisodeViewModel?>(value: nil)
    var receivedEpisode = BehaviorRelay<EpisodeViewModel?>(value: nil)
    
    private var characterListViewModel = BehaviorRelay<[SingleCharacterViewModel]?>(value: nil)
    
    //    var charactersURLList = PublishSubject<[String]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.dataSource = nil
        
        receivedEpisode.subscribe(onNext: {
            episode in
            
            self.episodeViewModel.accept(episode)
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        // MARK: - Table view data source
        
        characterListViewModel.map({ singleCharacter in
            singleCharacter
        })
        
        characterListViewModel. .bind(to: tableView.rx.items(cellIdentifier: "CharacterTableViewCell")) { index, model, cell in
            
            cell.textLabel?.text = model
            
            
        }.disposed(by: disposeBag)
        
        populateCharacters()
    }
    
    
    private func populateCharacters() {
        
        self.receivedEpisode.value?.episodeCharacters.asObservable().toArray().subscribe(onSuccess: { twoDArrayOfLinks in
            
            let linksArray = twoDArrayOfLinks
            
            for oneDArray in linksArray{
                for link in oneDArray {
                    let resource = Resource<Character>(url: URL(string: link)!)
                    
                    URLRequest.load(resource: resource)
                        .subscribe(onNext: { characterList in
                            
                            let characters = characterList
                            
                            var model = CharactersListViewModel()
                            
                            model.addCharacterViewModel(SingleCharacterViewModel(character: characters))
                            
                            self.characterListViewModel.accept(model)
                            
                        }).disposed(by: self.disposeBag)
                    
                    
                }
            }
            
        }).disposed(by: self.disposeBag)
        
    }
}
