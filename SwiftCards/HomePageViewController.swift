import UIKit
import MultipeerConnectivity

class HomePageViewController: UIViewController {
    var multipeer: MultipeerManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        Controllers.home = self
        multipeer = MultipeerManager.instance
        multipeer.session.delegate = multipeer
    }
    @IBAction func showConnectionOptions(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Swiftcards", message: "Do you want to Host or Join this session?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Join a session", style: .default, handler: { (_: UIAlertAction) in
            self.multipeer.advertiserAssistant.start()
            self.present(Controllers.joiner, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Host a session", style: .default, handler: { (_: UIAlertAction) in
            let browser = self.multipeer.browser!
            browser.delegate = self
            self.present(browser, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    @IBAction func setupSinglePlayerGame(_ sender: UIButton) {
        self.present(Controllers.setup, animated: true, completion: nil)
    }
}

extension HomePageViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        self.present(Controllers.setup, animated: true, completion: nil)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}
