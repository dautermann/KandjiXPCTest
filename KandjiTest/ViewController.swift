//
//  ViewController.swift
//  KandjiTest
//
//  Created by Michael Dautermann on 9/22/21.
//

import Cocoa

class ViewController: NSViewController {

    var path: String = "/"
    var fileArray: [String]? = nil
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var backButton: NSButton!
    @IBOutlet var pathLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.doubleAction = #selector(doubleClickOnResultRow)
        // I want to get rid of the constraint warnings so so very bad!
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let xpc = XPCCommunicators()
        xpc.fetchFolderInfoFor(path: path) { [weak self] (results) in
            guard let self = self else { return }
            if let folderArray = results as? NSArray as? [String] {
                self.fileArray = folderArray
                DispatchQueue.main.async {
                    if self.path.count > 1 {
                        self.path.append("/")
                        self.pathLabel.stringValue.append("/")
                    }
                    self.tableView.reloadData()
                }
            }
        }
        pathLabel.stringValue = path
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        if let window = self.view.window, let wc = window.windowController as? KandjiTestWindowController {
            if let rootVC = wc.navigationController.viewControllers.first as? ViewController {
                backButton.isHidden = ( self == rootVC )
            }
        }
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @objc func doubleClickOnResultRow() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateController(withIdentifier: "ViewController") as! ViewController
        // this array is +1 based because current path hides in position 0
        if let appendPath = fileArray?[tableView.clickedRow+1] {
            viewController.path = path + appendPath
            if let window = self.view.window, let wc = window.windowController as? KandjiTestWindowController {
                wc.navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func backButtonTouched(sender: NSButton) {
        if let window = self.view.window, let wc = window.windowController as? KandjiTestWindowController {
            if let rootVC = wc.navigationController.viewControllers.first as? ViewController, self != rootVC {
                wc.navigationController.popViewController(animated: true)
            }
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {

    func numberOfRows(in tableView: NSTableView) -> Int {
        if let numberOfRows = fileArray?.count, numberOfRows > 1 {
            // fileArray array is +1 based because current path hides in position 0
            return numberOfRows-1
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        guard let identifier = tableColumn?.identifier, let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else { return nil }
        
        // fileArray array is +1 based because current path hides in position 0
        let rowToFetch = row+1
        guard rowToFetch < fileArray?.count ?? 0, let name = fileArray?[rowToFetch] else { return nil }

        cell.textField?.stringValue = name
        
        return cell
    }
}
