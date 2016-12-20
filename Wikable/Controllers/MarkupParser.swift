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

    override init(){

    }

//    class func shared() -> MarkupParser {
//        if(_shared == nil) {
//            let fakeDispatchOnce: () = {
//                _shared = MarkupParser()
//            }()
//        }
//        return MarkupParser._shared
//    }

    func linkifyArticle(_ title: String="iPhone") -> String {

//        var plaintext = String()
//        var markup = String()
//
//
//
//
//        WikipediaAPI.getArticleFor( title) { (article) in
//            plaintext = article
//            print(plaintext)
//        }
//
//        WikipediaAPI.getRawMarkup(for: title) { (article) in
//            markup = article
//            print(markup)
//        }

        getStuff("iPhone")

        return ""
    }


    func getStuff(_ title: String) {
        WikipediaAPI.getArticleFor( title) { (plaintext) in
            WikipediaAPI.getRawMarkup(for: title) { (markup) in
                self.doStuff(plaintext, markup)
            }
        }
    }

    func doStuff(_ plaintext: String, _ markup: String) {
        print(plaintext)
        print("===========================================")
        print(markup)

    }
}
