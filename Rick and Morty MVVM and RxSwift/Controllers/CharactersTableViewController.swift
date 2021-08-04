//
//  CharactersTableViewController.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel Todorov on 4.08.21.
//

import UIKit
import RxSwift
import RxCocoa

class CharactersTableViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private var episodeViewModel = BehaviorRelay<EpisodeViewModel?>(value: nil)
    
    let episodesTVC = EpisodesTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Not receiving viewModels
        episodesTVC.selectedEpisodeSubjectObservable.subscribe(onNext: {
            episode in
            
            var existingEpisode = self.episodeViewModel
            self.episodeViewModel = existingEpisode
            
            
        }).disposed(by: disposeBag)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell", for: indexPath)

        episodeViewModel.value?.episodeName.asDriver(onErrorJustReturn: "Error retrieving data")
            .drive((cell.textLabel?.rx.text)!)
            .disposed(by: disposeBag)

        return cell
    }

}
