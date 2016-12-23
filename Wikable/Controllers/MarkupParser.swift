//
//  MarkupParser.swift
//  Wikable
//
//  Created by John D Hearn on 12/20/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

import Foundation

// This has to live outside the class for it to be available to a computed property,
// which we need for use of our singleton with bridging headers
// TODO: check to see if the normal singleton pattern works in the future.
private let sharedMarkupParser = MarkupParser()

class MarkupParser: NSObject {
    class var shared: MarkupParser{
        return sharedMarkupParser
    }
    override init(){}

    func linkifyArticle(_ title: String) -> String {

        MarkupParser.getPlaintextAndMarkupFor(title)

        return ""
    }


    private class func getPlaintextAndMarkupFor(_ title: String) {
        WikipediaAPI.getArticleFor( title) { (plaintext) in
            WikipediaAPI.getRawMarkup(for: title) { (markup) in
                MarkupParser.linkify(plaintext, markup)
            }
        }
    }

    private class func linkify(_ plaintext: String, _ markup: String) {
        // We're going to ignore lines that begin with:
        //   {, }, <, >, |, *, or whitespace
//        let pattern = "^[\\{\\}\\<\\>\\|\\*\\s]"
//        let regex = try! NSRegularExpression(pattern: pattern, options: [])
//        var wasFound = false
//
//        var markupLines = markup.components(separatedBy: .newlines)

//        for line in markupLines {
//            regex.enumerateMatches(in: line,
//                                   options: [],
//                                   range: NSRange(location: 0,
//                                   length: line.characters.count)) {
//                (match, _, stop) in
//            }
//        }

//        var plaintextLines: [String] = plaintext.components(separatedBy: .newlines)

    }
}
