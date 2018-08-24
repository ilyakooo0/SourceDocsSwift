//
//  Shell.swift
//  SourceDocsSwift
//
//  Created by Ilya Kos on 8/24/18.
//  Copyright © 2018 Ilya Kos. All rights reserved.
//

import Foundation

struct Shell {
    static func launch(executable: String, arguments: [String], launchDirectory: String?) -> Data? {
        let process = Process()
        if let launchDirectory = launchDirectory {
            process.currentDirectoryPath = launchDirectory
        }
        process.arguments = arguments
        if !FileManager.default.isExecutableFile(atPath: executable) {
            return nil
        }
        let executableURL = URL(fileURLWithPath: executable)
        process.executableURL = executableURL
        
        let pipe = Pipe()
        
        var out = Data()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: pipe.fileHandleForReading, queue: nil) { (_) in
            out.append(pipe.fileHandleForReading.readDataToEndOfFile())
        }
        
        process.standardOutput = pipe
        
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        process.launch()
        process.waitUntilExit()

        return out
    }
}
