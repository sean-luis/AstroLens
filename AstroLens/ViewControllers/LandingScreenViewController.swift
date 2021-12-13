import Foundation
import UIKit
import NASAApi

/*class LandingScreenViewController: UIViewController {
    enum Section: CaseIterable {
        case main
    }
    let landingScreenViewModel = LandingScreenViewModel(numberOfPhotosToRetrieve: 14)
    let searchBar = UISearchBar(frame: .zero)
    var photoOfTheDayCollectionView: PhotoOfTheDayCollectionViewController!
    var dataSource: UICollectionViewDiffableDataSource<Section, PhotoOfTheDay>!
    var nameFilter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mountains Search"
        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)
    }
}

extension LandingScreenViewController {
    /// - Tag: MountainsDataSource
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <ImageTitleDescriptionCollectionViewCell, PhotoOfTheDay> { (cell, indexPath, mountain) in
            // Populate the cell with our item description.
            cell.label.text = mountain.name
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PhotoOfTheDay>(collectionView: photoOfTheDayCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: PhotoOfTheDay) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    /// - Tag: MountainsPerformQuery
    func performQuery(with filter: String?) {
        let photos = NASAApi.shared.savedPhotos.filter({ $0.contains(filter) })
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoOfTheDay>()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension LandingScreenViewController {
    private func sizeForItem() -> CGSize {
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            // Activate compact constraints
            return CGSize(width: view.frame.width, height: 220)
        } else {
            // Activate regular constraints
            return CGSize(width: view.frame.width, height: 400)
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = contentSize.width > 800 ? 3 : 2
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(32))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            return section
        }
        return layout
    }

    func configureHierarchy() {
        view.backgroundColor = .systemBackground
        let layout = UICollectionViewFlowLayout()
        let collectionView = PhotoOfTheDayCollectionViewController(collectionViewLayout: layout)
        view.addSubview(collectionView.view)
        view.addSubview(searchBar)

        let views = ["cv": collectionView, "searchBar": searchBar]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(
            withVisualFormat: "V:[searchBar]-20-[cv]|", options: [], metrics: nil, views: views))
        constraints.append(searchBar.topAnchor.constraint(
            equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0))
        NSLayoutConstraint.activate(constraints)
        photoOfTheDayCollectionView = collectionView

        searchBar.delegate = self
    }
}

extension LandingScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}
*/
