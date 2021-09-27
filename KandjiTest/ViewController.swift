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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let xpc = XPCCommunicators()
        xpc.fetchFolderInfoFor(path: path) { (results) in
            
            Swift.print("got results into Swift \(results ?? "nothing!")")
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        return nil
    }

}
