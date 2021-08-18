//
//  EpisodesTableViewController.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel Todorov on 4.08.21.
//

import UIKit
import RxSwift
import RxCocoa

class EpisodesTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    var indexOfSelectedEpisode = 0
    
    private var episodeListViewModel = EpisodeListViewModel()
    
    private let selectedEpisode = PublishSubject<EpisodeViewModel>()
    
    var selectedEpisodeSubjectObservable: Observable<EpisodeViewModel> {
        return selectedEpisode.asObservable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        populateEpisodes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodeListViewModel.episodesVM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath)
        
        let episodeVM = self.episodeListViewModel.episodeAt(indexPath.row)
        
        episodeVM.episodeName.asDriver(onErrorJustReturn: "Error retrieving data")
            .drive((cell.textLabel?.rx.text)!)
            .disposed(by: disposeBag)
        
        cell.imageView?.image = UIImage(named: "icon")
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel!.numberOfLines = 0

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedEpisode.onNext(episodeListViewModel.episodeAt(indexPath.row))
        
        self.indexOfSelectedEpisode = indexPath.row
        
        self.performSegue(withIdentifier: "SegueToCharacters", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let charactersVC = segue.destination as? CharactersTableViewController
        
        charactersVC?.receivedEpisode.accept(self.episodeListViewModel.episodeAt(self.indexOfSelectedEpisode))
    }
    
    
    
    private func populateEpisodes() {
        
        for index in 1..<4{
            
            let resource = Resource<EpisodeList>(url: URL(string: "https://rickandmortyapi.com/api/episode?page=\(index)")!)
            
            URLRequest.load(resource: resource)
                .subscribe(onNext: { episodeList in
                    
                    let episodes = episodeList.results
                    self.episodeListViewModel.addEpisodes(episodes)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                }).disposed(by: disposeBag)
        }
        
    }
    
}
