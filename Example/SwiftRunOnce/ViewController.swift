import UIKit
import SwiftRunOnce

class ViewController: UIViewController {

    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var runOnceCountLabel: UILabel!

    private var viewCount = 0 {
        didSet {
            viewCountLabel.text = "View Count: \(viewCount)"
        }
    }

    private var runOnceViewCount = 0 {
        didSet {
            runOnceCountLabel.text = "RunOnce Count: \(runOnceViewCount)"
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewCount += 1
        runOnce {
            runOnceViewCount += 1
        }
    }
}

