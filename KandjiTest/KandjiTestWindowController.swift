//
//  KandjiTestWindowController.swift
//  KandjiTest
//
//  Created by Michael Dautermann on 9/27/21.
//

import AppKit
import BFNavigationController

class KandjiTestWindowController: NSWindowController {
    var navigationController: BFNavigationController = BFNavigationController()
    var initialVC: ViewController = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateController(withIdentifier: "ViewController") as! ViewController
        viewController.path = "/"
        return viewController
    }()

    override func windowWillLoad() {
        super.windowWillLoad()
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        if let window = self.window {
            navigationController = BFNavigationController.init(frame: NSMakeRect(0, 0, window.frame.size.width, window.frame.size.height), rootViewController: initialVC)
            window.contentView = navigationController.view
        }
    }

}
