//
//  MarkupParser.swift
//  Wikable
//
//  Created by John D Hearn on 12/20/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

import UIKit

// This has to live outside the class for it to be available to a computed property,
// which we need for use of our singleton with bridging headers
// TODO: check to see if the normal singleton pattern works in the future.
private let sharedMarkupParser = MarkupParser()

struct Regex {
    let pattern: String
    let options: NSRegularExpression.Options

    private var matcher: NSRegularExpression {
        return try! NSRegularExpression(pattern: self.pattern, options: self.options)
    }

    init(pattern: String, options: NSRegularExpression.Options = .init(rawValue: 0)) {
        self.pattern = pattern
        self.options = options
    }

    func match(_ string: String, options: NSRegularExpression.MatchingOptions = .init(rawValue: 0)) -> Bool {
        return self.matcher.numberOfMatches(in: string,
                                            options: options,
                                            range: NSMakeRange(0, string.utf16.count) ) != 0
    }
}

protocol RegularExpressionMatchable {
    func match(_ regex: Regex) -> Bool
}

extension String: RegularExpressionMatchable {
    func match(_ regex: Regex) -> Bool {
        return regex.match(self)
    }
}

func ~=<T: RegularExpressionMatchable>(pattern: Regex, matchable: T) -> Bool {
    return matchable.match(pattern)
}


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
                var decoratedLines = MarkupParser.decorate(plaintext)
                print(decoratedLines)
            }
        }
    }

    private class func decorate(_ plaintext: String) -> [NSAttributedString] {
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        let headlineFont = UIFont.preferredFont(forTextStyle: .headline)

        return plaintext.components(separatedBy: .newlines).flatMap{
            if MarkupParser.isHeading($0) {
                return NSAttributedString.init(string: $0,
                                               attributes: [NSFontAttributeName: headlineFont])
            } else {
                return NSAttributedString.init(string: $0,
                                               attributes: [NSFontAttributeName: bodyFont])
            }
        }
    }

    private class func isHeading(_ line: String) -> Bool {

        return false
    }


//    private class func linkify(_ plaintext: String, _ markup: String) {
//        // We're going to ignore lines that begin with:
//        //   {, }, <, >, |, *, or whitespace
//        let pattern = "^[\\{\\}\\<\\>\\|\\*\\s]"
//        let regex = try! NSRegularExpression(pattern: pattern, options: [])
//        var wasFound = false
//
//        var markupLines = markup.components(separatedBy: .newlines)
//
////        for line in markupLines {
////            regex.enumerateMatches(in: line,
////                                   options: [],
////                                   range: NSRange(location: 0,
////                                   length: line.characters.count)) {
////                (match, _, stop) in
////            }
////        }
//
//        var plaintextLines: [String] = plaintext.components(separatedBy: .newlines)
//
//    }
}
