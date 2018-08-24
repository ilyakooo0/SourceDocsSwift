//
//  main.swift
//  SourceDocsSwift
//
//  Created by Ilya Kos on 8/22/18.
//  Copyright © 2018 Ilya Kos. All rights reserved.
//

import Foundation

let args = Array(CommandLine.arguments.dropFirst())
let temp = FileManager.default.temporaryDirectory.appendingPathComponent("SourceDocsSwift/build\(Date().timeIntervalSince1970)")

var output = "docs.tex"
var directory: String?

var i = 0
while i < args.count {
    switch args[i] {
    case "-o":
        if i + 1 < args.count {
            i += 1
            output = args[i]
        }
    case "-i":
        if i + 1 < args.count {
            i += 1
            directory = args[i]
        }
    default:
        break
    }
    i += 1
}

let decoder = JSONDecoder()

guard let xcbTagetData = Shell.launch(executable: "/usr/bin/xcodebuild", arguments: ["-list", "-json"], launchDirectory: directory) else {
    print("""
    Make sure xcodebuild is installed
    
        xcode-select --install
    """)
    exit(1)
}

guard let xcbResponse = try? decoder.decode(XcodeBuildTargetResponse.self, from: xcbTagetData) else {
    print("Unexpected response from xcodebuild")
    exit(1)
}

let targets = xcbResponse.targets

var files: [String: [Object]] = [:]

for target in targets {
    try? FileManager.default.removeItem(at: temp)
    guard let skResponseData = Shell.launch(executable: "/usr/local/bin/sourcekitten", arguments: ["doc", "--", "-target", target, "CONFIGURATION_BUILD_DIR=\(temp)"], launchDirectory: directory) else {
        print("""
        Make sure sourcekitten is installed

            brew install sourcekitten
        """)
        exit(1)
    }
    
    guard let skResponse = try? decoder.decode([[String: SourceKittenResponse]].self, from: skResponseData) else {
        print("Unexpected response from sourcekitten")
        exit(1)
    }
    
    skResponse.forEach {files.merge($0.mapValues {$0.objects.filter {$0.type != .other}}, uniquingKeysWith: {a, b in a})}
}




let tex = TeXer.convert(objects: files.flatMap {$0.value})

try? tex.write(toFile: output, atomically: true, encoding: .utf8)

print("""
+-------+
| i l y |
| a k o |
| o o 0 |
+-------+
""")
