//
//  SourceKittenResponse.swift
//  SourceDocsSwift
//
//  Created by Ilya Kos on 8/22/18.
//  Copyright © 2018 Ilya Kos. All rights reserved.
//

import Foundation

struct SourceKittenResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case objects = "key.substructure"
    }
    
    var objects: [Object]
}

struct Object: Decodable {
    let type: ObjectType
    let name: String
    /// This is a documented field
    let declaration: String
    let documentation: String?
    let methods: [Subobject]
    let fields: [Subobject]
    
    private enum CodingKeys: String, CodingKey {
        case name = "key.name"
        case declaration = "key.parsed_declaration"
        case documenatation = "key.doc.comment"
        case type = "key.kind"
        case subobjects = "key.substructure"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decodeIfPresent(String.self, forKey: .type)
        if typeString == "source.lang.swift.decl.struct" {
            type = .struct
        } else if typeString == "source.lang.swift.decl.class" {
            type = .class
        } else {
            type = .other
            name = ""
            declaration = ""
            documentation = nil
            methods = []
            fields = []
            return
        }
        name = try container.decode(String.self, forKey: .name).replacingOccurrences(of: "_", with: "\\_")
        declaration = try container.decode(String.self, forKey: .declaration).replacingOccurrences(of: "_", with: "\\_")
        documentation = try container.decodeIfPresent(String.self, forKey: .documenatation)?.replacingOccurrences(of: "_", with: "\\_")
        let subobjects = try container.decode([Subobject].self, forKey: .subobjects)
        methods = subobjects.filter {$0.type == .method}
        fields = subobjects.filter {$0.type == .field}
    }
}

enum ObjectType {
    case `class`
    case `struct`
    case other
}

struct Subobject: Decodable {
    let type: SubobjectType
    let name: String
    let declaration: String
    let documentation: String?
    let typeName: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "key.name"
        case declaration = "key.parsed_declaration"
        case documenatation = "key.doc.comment"
        case type = "key.kind"
        case typeName = "key.typename"
    }
    
    private static let methodKeys: Set<String> = [
        "source.lang.swift.decl.function.method.static",
        "source.lang.swift.decl.function.method.instance"
    ]
    
    private static let fieldKeys: Set<String> = [
        "source.lang.swift.decl.var.instance",
        "source.lang.swift.decl.var.static"
    ]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringType = try container.decode(String.self, forKey: .type)
        if Subobject.methodKeys.contains(stringType) {
            type = .method
        } else if Subobject.fieldKeys.contains(stringType) {
            type = .field
        } else {
            type = .other
            name = ""
            declaration = ""
            documentation = nil
            typeName = ""
            return
        }
        name = try container.decode(String.self, forKey: .name).replacingOccurrences(of: "_", with: "\\_")
        declaration = try container.decode(String.self, forKey: .declaration).replacingOccurrences(of: "_", with: "\\_")
        documentation = try container.decodeIfPresent(String.self, forKey: .documenatation)?.replacingOccurrences(of: "_", with: "\\_")
        typeName = try container.decode(String.self, forKey: .typeName).replacingOccurrences(of: "_", with: "\\_")
    }
}

enum DecodingError: Error {
    case DecodingError
}

enum SubobjectType {
    case method
    case field
    case other
}
