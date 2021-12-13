import UIKit
import NotificationCenter
import NASAApi

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var todayLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var astroImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        todayLabel.isHidden = true
        titleLabel.isHidden = true
        astroImage.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            NASAApi.shared.fetchPhotoOfTheDay(at: 0, completionHandler: { [weak self] response in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowAnimatedContent, animations: {
                        self.titleLabel.text = response.title
                        self.todayLabel.text = response.date
                        self.astroImage.image = response.image
                        self.todayLabel.isHidden = false
                        self.titleLabel.isHidden = false
                        self.activityIndicator.isHidden = true
                        self.addCornerRadiusToAstroImageView()
                        self.addCornerRadiusToLabels()
                    }, completion: nil)
                }
            })
        }
    }
    
    func addCornerRadiusToAstroImageView() {
        astroImage.isHidden = false
        astroImage.layer.cornerRadius = 8
        astroImage.clipsToBounds = true
    }
    
    func addCornerRadiusToLabels() {
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}
