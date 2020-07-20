import Foundation
import UIKit
import NASAApi

// Prefetching guide: https://www.raywenderlich.com/7341-uicollectionview-tutorial-prefetching-apis

class PhotoOfDayCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let kCellIdentifier = "ImageTitleDescriptionCollectionViewCell"
    private let photoOfDayViewModel = PhotoOfTheDayViewModel(numberOfPhotosToRetrieve: 14)
    let loadingQueue = OperationQueue()
    var loadingOperations: [IndexPath: DataLoadOperation] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        configurePastelView()
    }
    
    private func setupViewController() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ImageTitleDescriptionCollectionViewCell", bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: kCellIdentifier)
        collectionView.isPrefetchingEnabled = true
        collectionView?.prefetchDataSource = self
    }
    
    private func configurePastelView() {
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as? ImageTitleDescriptionCollectionViewCell else {
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
        
        let updateCellClosure: (PhotoOfTheDay?) -> Void = { [weak self] response in
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let response = response else { return }
                self.handleCellConfiguration(response: response, image: response.image, cell: cell)
                self.loadingOperations.removeValue(forKey: indexPath)
            }
        }
        
        if let existingDataLoader = loadingOperations[indexPath] {
            if let response = existingDataLoader.response {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.handleCellConfiguration(response: response, image: response.image, cell: cell)
                    self.loadingOperations.removeValue(forKey: indexPath)
                }
            } else {
                // No response yet. Updating the completion handler fixes cell waiting to load issue
                existingDataLoader.updateCompletionHandler(with: updateCellClosure)
            }
        } else {
            let dataLoader = DataLoadOperation(atIndex: indexPath.section) { [weak self] response in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.handleCellConfiguration(response: response, image: response.image, cell: cell)
                    self.loadingOperations.removeValue(forKey: indexPath)
                }
            }
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageTitleDescriptionCollectionViewCell else { return }
        cell.flipLikedState()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photoOfDayViewModel.numberOfPhotosToRetrieve
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func sizeForItem() -> CGSize {
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            // Activate compact constraints
            return CGSize(width: view.frame.width, height: 220)
        } else {
            // Activate regular constraints
            return CGSize(width: view.frame.width, height: 400)
        }
    }
    
    // MARK: - Cell configuration methods
    
    private func handleCellConfiguration(response: PhotoOfTheDay, image: UIImage?, cell: ImageTitleDescriptionCollectionViewCell) {
        animateCellConfiguration(cell: cell, date: response.date, title: response.title, image: image ?? photoOfDayViewModel.defaultImage)
    }
    
    private func animateCellConfiguration(cell: ImageTitleDescriptionCollectionViewCell, date: String, title: String, image: UIImage) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowAnimatedContent, animations: {
            cell.setCellState(to: .hasContent)
            cell.configure(date: date, title: title, astroImage: image)
            cell.setNeedsLayout()
            cell.setNeedsDisplay()
        }, completion: nil)
    }
}

extension PhotoOfDayCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = loadingOperations[indexPath] { continue }
            let dataLoader = DataLoadOperation(atIndex: indexPath.section) { [weak self] response in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.loadingOperations.removeValue(forKey: indexPath)
                }
            }
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
        }
    }
}
