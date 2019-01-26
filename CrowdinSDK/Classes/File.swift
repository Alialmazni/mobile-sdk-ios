//
//  File.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 1/25/19.
//  Copyright © 2019 Crowdin. All rights reserved.
//

import Foundation

enum FileStatus {
    case file
    case directory
    case none
}

protocol FileStatusable {
    var status: FileStatus { get }
}

extension FileStatusable where Self : Path {
    var status: FileStatus {
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory:&isDir) {
            if isDir.boolValue {
                return .directory
            } else {
                return .file
            }
        } else {
            return .none
        }
    }
}

protocol Path {
    var path: String { get set}
}

class File: Path, FileStatusable {
    var path: String
    let name: String
    let type: String
    
    
    init(path: String) {
        self.path = path
        let url = URL(fileURLWithPath: path)
        guard let lastPathComponent = url.pathComponents.last else {
            fatalError("Error while creating a file at path - \(path)")
        }
        let components = lastPathComponent.split(separator: ".")
        guard components.count > 0 && components.count <= 2 else {
            fatalError("Error while detecting file name and type, from path - \(path)")
        }
        if components.count == 1 {
            //Hidden file f.e. .DS_Store
            name = ""
            type = String(components[0])
        } else {
            name = String(components[0])
            type = String(components[1])
        }
    }
    
    var isCreated: Bool { return status == .file }
    
    var content: Data? {
        guard self.isCreated else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}