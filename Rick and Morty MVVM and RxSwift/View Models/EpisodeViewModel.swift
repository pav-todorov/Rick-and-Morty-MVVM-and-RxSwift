//
//  EpisodeViewModel.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel Todorov on 4.08.21.
//

import Foundation
import RxSwift
import RxCocoa

struct EpisodeListViewModel {
    var episodesVM = [EpisodeViewModel]()
}

extension EpisodeListViewModel {
    mutating func addEpisodes(_ episodes: [Episode]) {
        self.episodesVM += episodes.compactMap(EpisodeViewModel.init)
    }
}

extension EpisodeListViewModel {
    func episodeAt(_ index: Int) -> EpisodeViewModel {
        return self.episodesVM[index]
    }
}

struct EpisodeViewModel {
    let episode: Episode
    
    init(_ episode: Episode) {
        self.episode = episode
    }
}

extension EpisodeViewModel {
    
    var episodeName: Observable<String> {
        return Observable<String>.just(episode.name)
    }
    
    var episodeDigits: Observable<String> {
        return Observable<String>.just(episode.episode)
    }
    
    
    
}
