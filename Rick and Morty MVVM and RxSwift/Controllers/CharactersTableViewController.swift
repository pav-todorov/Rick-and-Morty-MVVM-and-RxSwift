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
import SDWebImage

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
        
        characterObject.bind(to: tableView.rx.items(cellIdentifier: "CharacterTableViewCell")) { index, model, cell in
            
            cell.imageView?.sd_setImage(with: URL(string: model.image), placeholderImage: nil)

            cell.textLabel?.text = model.name


        }.disposed(by: disposeBag)
            
        populateCharacters()

      
        self.characterObject.onNext(toAppendCharacter)
        
        tableView.rx.modelSelected(Character.self)
            .subscribe(onNext: { [weak self] model in
                
                guard let strongSelf = self else { return }
                
                guard let singleCharacterVC = strongSelf.storyboard?.instantiateViewController(identifier: "SingleCharacterViewController") as? SingleCharacterViewController else {
                    fatalError("SingleCharacterViewController not found")
                }
                
                
                singleCharacterVC.receivedCharacter.accept(model)
                
                
                strongSelf.navigationController?.pushViewController(singleCharacterVC, animated: true)
                
                
            }).disposed(by: disposeBag)
    }

    
    
    /// Gets characters from the URLs that have been passed by the EpisodeTableViewController
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
                                self.characterObject.onNext(toAppendCharacter)
                                
                                
                                
                                
                            }).disposed(by: self.disposeBag)
                        
                    }
                    
                }).disposed(by: self.disposeBag)
                
            }
            
        }).disposed(by: disposeBag)
        
//        self.characterObject.onNext(toAppendCharacter)
        
        
        
        
        
    }
    
}
