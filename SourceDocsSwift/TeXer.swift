//
//  TeXer.swift
//  SourceDocsSwift
//
//  Created by Ilya Kos on 8/23/18.
//  Copyright © 2018 Ilya Kos. All rights reserved.
//

struct TeXer {
    static func convert(objects: [Object], with style: TexType = .laTeX(2)) -> String {
        return """
        \\\(style.section(for: 1)){Описание классов и структур}
        
        \\begin{longtable}{|p{0.55\\textwidth} | p{0.4\\textwidth}|}
        \\hline
        \\textbf{Класс или стркура} & \\textbf{Описание} \\\\ \\hline
        \( objects.map {"\\texttt{\($0.declaration)} & \($0.documentation ?? "{\\color{red} TODO}") \\\\ \\hline"} .joined(separator: "\n") )
        \\end{longtable}
        
        
        \\\(style.section(for: 1)){Описание полей классов и структур}
        
        \(
        objects.compactMap {
        if $0.fields.count > 0 {
        return """
        \\\(style.section(for: 2))*{\\texttt{\($0.declaration)}}
        
        \\begin{longtable}{|p{0.55\\textwidth} | p{0.4\\textwidth}|}
        \\hline
        \\textbf{Поле} & \\textbf{Описание} \\\\ \\hline
        \( $0.fields.map {"\\texttt{\($0.declaration.prefix {$0 != "="})} & {\\color{red} TODO} \\\\ \\hline"} .joined(separator: "\n") )
        \\end{longtable}
        
        """
        } else {
        return nil
        }
        } .joined(separator: "\n")
        )
        
        \\\(style.section(for: 1)){Описание методов классов и структур}
        
        \(
        objects.compactMap {
        if $0.methods.count > 0 {
        return """
        \\\(style.section(for: 2))*{\\texttt{\($0.declaration)}}
        
        \\begin{longtable}{|p{0.55\\textwidth} | p{0.4\\textwidth}|}
        \\hline
        \\textbf{Метод} & \\textbf{Описание} \\\\ \\hline
        \( $0.methods.map {"\\texttt{\($0.declaration)} & \($0.documentation ?? "{\\color{red} TODO}") \\\\ \\hline"} .joined(separator: "\n") )
        \\end{longtable}
        
        """
        } else {
        return nil
        }
        } .joined(separator: "\n")
        )
        """
    }
    
    enum TexType {
        case techDoc(Int)
        case laTeX(Int)
        
        func section(`for` level: Int) -> String {
            switch self {
            case .laTeX(let i):
                return String(repeating: "sub", count: i+level-2).appending("section")
            case .techDoc(let i):
                switch i+level-2 {
                case 0:
                    return "addition"
                default:
                    return TexType.laTeX(i).section(for: level)
                }
            }
        }
        var levelOffset: Int {
            get {
                switch self {
                case .laTeX(let i):
                    return i
                case .techDoc(let i):
                    return i
                }
            }
            set {
                switch self {
                case .laTeX(_):
                    self = .laTeX(newValue)
                case .techDoc(_):
                    self = .techDoc(newValue)
                }
            }
        }
    }
}
