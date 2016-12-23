//
//  MarkupParser.swift
//  Wikable
//
//  Created by John D Hearn on 12/20/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

import UIKit

extension Array where Element: NSAttributedString {
    func joined(separator: NSAttributedString) -> NSAttributedString {
        var isFirst = true
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if isFirst {
                isFirst = false
            } else {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }

    func joined(separator: String) -> NSAttributedString {
        return joined(separator: NSAttributedString(string: separator))
    }
}

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

    func match(_ string: String,
                options: NSRegularExpression.MatchingOptions = .init(rawValue: 0)) -> Bool {
        return self.matcher.numberOfMatches(in: string,
                                            options: options,
                                            range: NSMakeRange(0, string.utf16.count) ) != 0
    }

    func extract(_ string: String,
                  options: NSRegularExpression.MatchingOptions = .init(rawValue: 0),
                 template: String = "$1$2") -> String {
        let range = NSRange(location:0, length:string.utf16.count)
        return self.matcher.stringByReplacingMatches(in: string,
                                                options: options,
                                                  range: range,
                                           withTemplate: template)

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


private let kTitle = UIFont.preferredFont(forTextStyle: .title1)
private let kHeadline = UIFont.preferredFont(forTextStyle: .headline)
private let kSubHeadline = UIFont.preferredFont(forTextStyle: .subheadline)
private let kSubSubHeadline = UIFont.preferredFont(forTextStyle: .title2)
private let kBody = UIFont.preferredFont(forTextStyle: .body)

// This has to live outside the class for it to be available to a computed property,
// which we need for use of our singleton with bridging headers
// TODO: check to see if the normal singleton pattern works in the future.
private let sharedMarkupParser = MarkupParser()


class MarkupParser: NSObject {
    class var shared: MarkupParser{
        return sharedMarkupParser
    }
    override init(){}

    private class func decorate(_ title: String, _ plaintext: String) -> [NSAttributedString] {

        let decoratedTitle =
            NSMutableAttributedString(string: "\(title)\n",
                                      attributes: [NSFontAttributeName: kTitle])
        var decoratedLines = plaintext.components(separatedBy: .newlines).flatMap{
            return MarkupParser.setFontStyle($0)
        }

        decoratedLines.insert(decoratedTitle, at: 0)
        return decoratedLines
    }



    private class func setFontStyle(_ line: String) -> NSAttributedString {
        var style: UIFont
        var string: String

        let subSubHeadline = Regex(pattern: ".*====\\s*(.+)\\s*====.*")
        let subHeadline = Regex(pattern: ".*===\\s*(.+)\\s*===.*")
        let headline = Regex(pattern: ".*==\\s*(.+)\\s*==.*")

        switch(line){
        case subSubHeadline:
            style = kSubSubHeadline
            string = subSubHeadline.extract(line)
        case subHeadline:
            style = kSubHeadline
            string = subHeadline.extract(line)
        case headline:
            style = kHeadline
            string = headline.extract(line)
        default:
            style = kBody
            string = line
        }
        return NSAttributedString.init(string: string,
                                       attributes: [NSFontAttributeName: style])
    }


    private class func getPlaintextAndMarkupFor(_ title: String) {
        WikipediaAPI.getArticleFor( title ) { (plaintext) in
            WikipediaAPI.getRawMarkup(for: title) { (markup) in

            }
        }
    }

    func decoratePlaintext(_ title: String,
                           completion: @escaping (NSAttributedString) -> ()) {
        WikipediaAPI.getArticleFor( title ) { (plaintext) in
            let decoratedLines = MarkupParser.decorate(title, plaintext)
            let decoratedText = decoratedLines.joined(separator: "\n")
            //print(decoratedText)
            completion(decoratedText)
        }
    }


//    func linkifyArticle(_ title: String) -> String {
//
//        MarkupParser.getPlaintextAndMarkupFor(title)
//        
//        return ""
//    }
}

