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

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let destinationVC = segue.destination as? EpisodesTableViewController
        
            destinationVC?.selectedEpisodeSubjectObservable.subscribe(onNext: { [unowned self] selectedEpisode in
                
                var existingCharacters = self.episodeViewModel.value
                existingCharacters = selectedEpisode
                
                self.episodeViewModel.accept(existingCharacters)
               
                
            }).disposed(by: disposeBag)
        
        
    }

}
