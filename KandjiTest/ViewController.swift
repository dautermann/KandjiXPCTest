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
    var fileAttributes: [String:Any]? = nil
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var backButton: NSButton!
    @IBOutlet var pathLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.doubleAction = #selector(doubleClickOnResultRow)
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
            } else {
                self.fileAttributes = results as? NSDictionary as? [String:Any]
                DispatchQueue.main.async {
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
        if let appendPath = fileArray?[tableView.clickedRow] {
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
            return numberOfRows
        }
        return fileAttributes == nil ? 0 : 1
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        var identifier = NSUserInterfaceItemIdentifier("cells")
        if fileArray == nil {
            identifier = NSUserInterfaceItemIdentifier("FileDetailCell")
            if let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? FileAttributeTableCellView {
                cell.textView.string = "\(fileAttributes as AnyObject)"
                return cell
            }
        }
        if let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView, let fileArray = fileArray, row < fileArray.count {
            let name = fileArray[row]
            cell.textField?.stringValue = name
            return cell
        }
        return nil
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return fileArray == nil ? 100.0 : 16.0
    }
}

class FileAttributeTableCellView : NSTableCellView {
    @IBOutlet var textView: NSTextView!
}
