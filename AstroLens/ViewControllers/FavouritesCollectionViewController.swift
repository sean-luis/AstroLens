import Foundation
import UIKit
import NASAApi
import DataStore

final class FavouritesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let kCellIdentifier = "ImageTitleDescriptionCollectionViewCell"
    private let favouritesScreenViewModel = FavouritesScreenViewModel()
    private var indexOfCellBeforeDragging = 0
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    private var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        addGradientViewOnBackground()
        print(favouritesScreenViewModel.favouritedPhotos.count)
        print(favouritesScreenViewModel.favouritedPhotos)
    }
    
    private func setupViewController() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ImageTitleDescriptionCollectionViewCell", bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: kCellIdentifier)
        collectionView.isPrefetchingEnabled = false
        collectionViewFlowLayout.minimumLineSpacing = .zero
        collectionViewFlowLayout.minimumInteritemSpacing = .zero
    }
    
    private func addGradientViewOnBackground() {
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 2.0
        pastelView.setColors([UIColor.spaceBlack,
                              UIColor.darkGray,
                              UIColor.black,
                              UIColor.shipsOfficer])
        pastelView.startAnimation()
        
        collectionView.backgroundView = pastelView
    }
    
    // MARK: - CollectionView delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? ImageTitleDescriptionCollectionViewCell, !favouritesScreenViewModel.favouritedPhotos.isEmpty else {
            return UICollectionViewCell()
        }
        cell.setCellState(to: .loadingContent)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        cell.contentView.layer.masksToBounds = true
        
        guard let cell = cell as? ImageTitleDescriptionCollectionViewCell else { return }
        let savedPhoto = favouritesScreenViewModel.favouritedPhotos[indexPath.row]
        animateCellConfiguration(cell: cell, date: savedPhoto.date, title: savedPhoto.title, image: savedPhoto.image ?? favouritesScreenViewModel.defaultImage)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouritesScreenViewModel.favouritedPhotos.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return adjustedCollectionViewInset()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem()
    }
    
    private func sizeForItem() -> CGSize {
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            // Activate compact constraints
            if favouritesScreenViewModel.favouritedPhotos.count <= 4 {
                return CGSize(width: collectionView.frame.width, height: 220)
            } else {
                return CGSize(width: collectionView.frame.width / 2 , height: 220)
            }
        } else {
            // Activate regular constraints
            return CGSize(width: collectionView.frame.width, height: 220)
        }
    }
    
    private func adjustedCollectionViewInset() -> UIEdgeInsets {
        var adjustedInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            guard let tabBarController = tabBarController else { return adjustedInset }
            let tabBarHeight = tabBarController.tabBar.frame.height
            adjustedInset = UIEdgeInsets(top: 20, left: .zero, bottom: tabBarHeight, right: .zero)
        } else {
            adjustedInset = .zero
        }
        collectionView.contentInset = adjustedInset
        collectionView.scrollIndicatorInsets = adjustedInset
        return adjustedInset
    }
    
    private func animateCellConfiguration(cell: ImageTitleDescriptionCollectionViewCell, date: String, title: String, image: UIImage) {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .allowAnimatedContent, animations: {
            cell.setCellState(to: .hasContent)
            cell.configure(date: date, title: title, astroImage: image, isFavourite: true)
            cell.setNeedsLayout()
            cell.setNeedsDisplay()
        }, completion: nil)
    }
}
