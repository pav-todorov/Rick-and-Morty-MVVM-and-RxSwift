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
import Nuke
import RxAnimated

class CharactersTableViewController: UITableViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
//    var toAppendCharacter:[Character] = []
    
    var foundCharacter = BehaviorRelay<[Character]>(value: [])
    
    let options = ImageLoadingOptions(
        placeholder: UIImage(named: "icon"),
        transition: .fadeIn(duration: 0.33))
    
    private let disposeBag = DisposeBag()
    var episodeViewModel = BehaviorRelay<EpisodeViewModel?>(value: nil)
    var receivedEpisode = BehaviorRelay<EpisodeViewModel?>(value: nil)
    
//    var charactersListViewModel: CharactersListViewModel?
    
    var characterObject = BehaviorRelay<[Character]>(value: [])
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = nil
        
        //MARK: - Setting the search bar
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search a character"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
//        searchController.searchBar.searchTextField.textColor = .white
        
        receivedEpisode.subscribe(onNext: {
            episode in
            
            self.episodeViewModel.accept(episode)
            
            
        }).disposed(by: disposeBag)
        
        
        // MARK: - Table view data source
        
        
        
        characterObject.bind(to: tableView.rx.items(cellIdentifier: "CharacterTableViewCell")) { index, model, cell in
            
            //            cell.imageView?.sd_setImage(with: URL(string: model.image), placeholderImage: nil)
            
            
            
            Nuke.loadImage(with: ImageRequest(url: URL(string: model.image)!, processors: [
                ImageProcessors.Circle(border: ImageProcessingOptions.Border(color: .white, width: 20, unit: .points)),
                
            ]), options: self.options, into: cell.imageView!)
            
            
            cell.imageView?.image = UIImage(named: "icon")
            
            cell.accessoryType = .disclosureIndicator
            cell.textLabel!.numberOfLines = 0
            cell.imageView?.layer.shadowColor = UIColor.gray.cgColor
            cell.imageView?.layer.shadowOpacity = 0.5
            cell.imageView?.layer.shadowOffset = .zero
            cell.imageView?.layer.shadowRadius = 5
            
            
            cell.textLabel?.text = model.name
            
            
        }.disposed(by: disposeBag)
        
        populateCharacters()
        
        
//        self.characterObject.onNext(toAppendCharacter)
        
        tableView.rx.modelSelected(Character.self)
            .subscribe(onNext: { [weak self] model in
                
                guard let strongSelf = self else { return }
                
                guard let singleCharacterVC = strongSelf.storyboard?.instantiateViewController(identifier: "SingleCharacterViewController") as? SingleCharacterViewController else {
                    fatalError("SingleCharacterViewController not found")
                }
                
                
                singleCharacterVC.receivedCharacter.accept(model)
                
                
                strongSelf.navigationController?.pushViewController(singleCharacterVC, animated: true)
                
                
            }).disposed(by: disposeBag)
        
        //MARK: - searching characters
        searchController.searchBar.rx.text.orEmpty.distinctUntilChanged().filter{ !$0.isEmpty }.subscribe(onNext: { query in
            
            print("printing query", query)
            
            self.characterObject.map{ $0.filter { $0.name.lowercased().contains(query.lowercased()) } }.subscribe(onNext: { result in
                
                
                
                self.foundCharacter.accept(self.foundCharacter.value + result)
                
                print("printing result", self.foundCharacter.value.count)

                
            }).disposed(by: self.disposeBag)
            
//            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        self.searchController.searchBar.rx.textDidEndEditing.subscribe(onNext: {
            self.foundCharacter = BehaviorRelay<[Character]>(value: [])
            
            print("printing result after cancel", self.foundCharacter.value.count)
            
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
                                
                                
//                                toAppendCharacter.append(character)
//                                self.characterObject.accept(characterObject.value! + [character])
                                
                                self.characterObject.accept(characterObject.value + [character])
                                
                                
                                
                                
                            }).disposed(by: self.disposeBag)
                        
                    }
                    
                }).disposed(by: self.disposeBag)
                
            }
            
        }).disposed(by: disposeBag)
        
        //        self.characterObject.onNext(toAppendCharacter)
        
        
        
        
 
        
        
    }
    
}
