//
//  TeXer.swift
//  SourceDocsSwift
//
//  Created by Ilya Kos on 8/23/18.
//  Copyright © 2018 Ilya Kos. All rights reserved.
//

struct TeXer {
    static func convert(objects: [Object]) -> String {
        return """
        \\subsection{Описание классов и структур}
        
        \\begin{longtable}{|p{0.55\\textwidth} | p{0.4\\textwidth}|}
        \\hline
        \\textbf{Класс или стркура} & \\textbf{Описание} \\\\ \\hline
        \( objects.map {"\\texttt{\($0.declaration)} & \($0.documentation ?? "{\\color{red} TODO}") \\\\ \\hline"} .joined(separator: "\n") )
        \\end{longtable}

        
        \\subsection{Описание полей классов и структур}
        
        \(
        objects.compactMap {
        if $0.fields.count > 0 {
        return """
        \\subsubsection{\\texttt{\($0.declaration)}}
        
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

        \\subsection{Описание методов классов и структур}
        
        \(
        objects.compactMap {
        if $0.methods.count > 0 {
        return """
        \\subsubsection{\\texttt{\($0.declaration)}}
        
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
}
