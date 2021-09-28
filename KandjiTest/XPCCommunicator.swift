//
//  XPCCommunicator.swift
//  KandjiTest
//
//  Created by Michael Dautermann on 9/26/21.
//

import Foundation

class XPCCommunicators {
    var connectionToService: NSXPCConnection
    
    init() {
        connectionToService = NSXPCConnection.init(serviceName: "com.myke.FileInvestigator")
        connectionToService.remoteObjectInterface = NSXPCInterface(with: FileInvestigatorProtocol.self)
        connectionToService.resume()
    }
    
    func fetchFolderInfoFor(path: String, completion: @escaping (Any?) -> ()) {
        if let proxy = connectionToService.remoteObjectProxy as? FileInvestigatorProtocol {
            proxy.fetchFolderInfo(forPath: path) { (reply) in
                completion(reply)
            }
        }
    }
}
