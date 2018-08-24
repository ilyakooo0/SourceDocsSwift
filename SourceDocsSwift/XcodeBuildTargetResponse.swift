//
//  XcodeBuildTargetResponse.swift
//  SourceDocsSwift
//
//  Created by Ilya Kos on 8/24/18.
//  Copyright © 2018 Ilya Kos. All rights reserved.
//

struct XcodeBuildTargetResponse: Decodable {
    private enum OuterKeys: CodingKey {
        case project
    }
    
    private enum InnerKeys: CodingKey {
        case targets
    }
    
    let targets: [String]
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy: InnerKeys.self, forKey: .project)
        targets = try innerContainer.decode([String].self, forKey: .targets)
    }
}
