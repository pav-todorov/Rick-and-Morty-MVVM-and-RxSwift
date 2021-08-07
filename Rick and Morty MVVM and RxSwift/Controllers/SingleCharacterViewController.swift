//
//  SingleCharacterViewController.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel on 7.08.21.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class SingleCharacterViewController: UIViewController {
    
    var receivedCharacter = BehaviorRelay<Character?>(value: nil)
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        receivedCharacter.map{ model in
//            self.characterImageView.sd_setImage(with: URL(string: model!.image), placeholderImage: nil)
//
//
//        }
        
        receivedCharacter.subscribe { characterModel in
            
            self.characterImageView.sd_setImage(with: URL(string: characterModel!.image), placeholderImage: nil)
        }

        
        receivedCharacter.map { $0?.name }.bind(to: self.characterNameLabel.rx.text).disposed(by: disposeBag)
        receivedCharacter.map { $0?.status }.bind(to: self.statusLabel.rx.text).disposed(by: disposeBag)
        receivedCharacter.map { $0?.species }.bind(to: self.speciesLabel.rx.text).disposed(by: disposeBag)
        receivedCharacter.map { $0?.gender }.bind(to: self.genderLabel.rx.text).disposed(by: disposeBag)
        
    }
    


}
