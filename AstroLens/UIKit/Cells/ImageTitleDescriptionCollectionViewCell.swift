import UIKit

class ImageTitleDescriptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var astroImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favouriteButton: FavouriteButton!
    @IBOutlet weak var loadingView: UIView!
        
    enum CellState {
        case loadingContent
        case hasContent
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        dateLabel.adjustsFontForContentSizeCategory = true
        titleLabel.adjustsFontForContentSizeCategory = true
        addCornerRadiusWithShadow()
        restrictUserContentSizePreferenceToSpecifiedSizes()
        setHeightOfImageViewForSizeClasses()
    }
     
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection else { return }
        handleContentSizeCategoryChanges(using: previousTraitCollection.preferredContentSizeCategory)
        handleSizeClassChanges(using: previousTraitCollection)
    }
    
    func setCellState(to cellState: CellState) {
        switch cellState {
        case .loadingContent:
            loadingIndicator.startAnimating()
            astroImageView.isHidden = true
            dateLabel.isHidden = true
            titleLabel.isHidden = true
            loadingView.isHidden = false
        case .hasContent:
            loadingIndicator.stopAnimating()
            astroImageView.isHidden = false
            dateLabel.isHidden = false
            titleLabel.isHidden = false
            loadingView.isHidden = true
        }
    }
    
    func configure(date: String, title: String, astroImage: UIImage) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        self.astroImageView.image = astroImage
        self.dateLabel.text = date
        self.titleLabel.text = title
        setCellState(to: .hasContent)
    }
    
    func flipLikedState() {
        //favouriteButton.flipLikedState()
    }
    
    func addCornerRadiusWithShadow() {
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.layer.cornerRadius = 8
        astroImageView.layer.cornerRadius = 8
        loadingView.layer.cornerRadius = 8
        dateLabel.layer.cornerRadius = 4
        titleLabel.layer.cornerRadius = 4
    }
}

// MARK: - Dynamic fonts
extension ImageTitleDescriptionCollectionViewCell {
    func handleContentSizeCategoryChanges(using previousPreferredContentSizeCategory: UIContentSizeCategory) {
        let currentPreferredContentSizeCategory = traitCollection.preferredContentSizeCategory
        if currentPreferredContentSizeCategory != previousPreferredContentSizeCategory {
            restrictUserContentSizePreferenceToSpecifiedSizes()
        }
    }
    
    func restrictUserContentSizePreferenceToSpecifiedSizes() {
        let currentPreferredContentSizeCategory = traitCollection.preferredContentSizeCategory
        
        // Specified content size categories
        let specifiedContentSizesCategoriesForSmall: [UIContentSizeCategory] = [.extraSmall, .small]
        let specifiedContentSizesCategoriesForMedium: [UIContentSizeCategory] = [.medium, .large, .accessibilityMedium, .accessibilityLarge]
        let specifiedContentSizesCategoriesForLarge: [UIContentSizeCategory] = [.extraLarge, .extraExtraLarge, .extraExtraExtraLarge, .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge]
        
        // Font descriptors
        let fontDescriptorForDate = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body, compatibleWith: traitCollection)
        let fontDescriptorForTitle = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1, compatibleWith: traitCollection)
        
        if specifiedContentSizesCategoriesForSmall.contains(currentPreferredContentSizeCategory) {
            dateLabel.font = UIFont(descriptor: fontDescriptorForDate, size: 12)
            titleLabel.font = UIFont(descriptor: fontDescriptorForTitle, size: 12)
        } else if specifiedContentSizesCategoriesForMedium.contains(currentPreferredContentSizeCategory) {
            dateLabel.font = UIFont(descriptor: fontDescriptorForDate, size: 15)
            titleLabel.font = UIFont(descriptor: fontDescriptorForTitle, size: 15)
        } else if specifiedContentSizesCategoriesForLarge.contains(currentPreferredContentSizeCategory) {
            dateLabel.font = UIFont(descriptor: fontDescriptorForDate, size: 22)
            titleLabel.font = UIFont(descriptor: fontDescriptorForTitle, size: 22)
        }
    }
}

// MARK: - Size classes
extension ImageTitleDescriptionCollectionViewCell {
    func handleSizeClassChanges(using previousTraitCollection: UITraitCollection) {
        if traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass
            || traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass {
            setHeightOfImageViewForSizeClasses()
        }
    }
    
    func setHeightOfImageViewForSizeClasses() {
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            // Activate compact constraints
            // imageViewHeightConstraint.constant = 220
        } else {
            // Activate regular constraints
            // imageViewHeightConstraint.constant = 400
        }
    }
}
