//  Created by Alejandrina Patrón López on 6/8/20.
//  Copyright © 2020 Alejandrina Patrón López. All rights reserved.
//  Source -> https://github.com/apatronl/Heart-Button-Demo

import Foundation
import UIKit

class FavouriteButton: UIButton {
    private var isLiked = false
    
    private let unlikedImage = UIImage(named: "fav_empty")
    private let likedImage = UIImage(named: "fav_full")
    
    private let unlikedScale: CGFloat = 0.7
    private let likedScale: CGFloat = 1.3
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setImage(unlikedImage, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func flipLikedState() {
        isLiked = !isLiked
        animate()
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.1, animations: { [unowned self] in
            let newImage = self.isLiked ? self.likedImage : self.unlikedImage
            let newScale = self.isLiked ? self.likedScale : self.unlikedScale
            self.transform = self.transform.scaledBy(x: newScale, y: newScale)
            self.setImage(newImage, for: .normal)
        }, completion: { [unowned self] _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
