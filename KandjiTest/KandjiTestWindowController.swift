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

    override func windowDidLoad() {
        super.windowDidLoad()
        if let window = self.window {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateController(withIdentifier: "ViewController") as! ViewController
            viewController.path = "/"
            navigationController = BFNavigationController.init(frame: NSMakeRect(0, 0, window.frame.size.width, window.frame.size.height), rootViewController: viewController)
            window.contentView?.addSubview(navigationController.view)
        }
    }

}
