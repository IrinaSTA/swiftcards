import UIKit

class JoinerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
    }
    func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
