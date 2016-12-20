//
//  WikipediaAPI.m
//  Wikable
//
//  Created by John Shaff on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "WikipediaAPI.h"

@interface WikipediaAPI ()



@end


@implementation WikipediaAPI

NSString *baseURL = @"https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&titles=";

// GRAB THE SEARCH BAR TEXT!!!
NSString *searchTerm = @"iphone 7";


+(void) searchWikipedia {
    NSString *fixedTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *fixedTermWithBaseURL = [baseURL stringByAppendingString:fixedTerm];
    NSURL *fullURL = [NSURL URLWithString:fixedTermWithBaseURL];
    
    NSLog(@"%@", fullURL);


    NSURLSessionDataTask *fetchWiki = [[NSURLSession sharedSession] dataTaskWithURL:fullURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error!=nil) {
            NSLog(@"web service error:%@",error);
        } else {
            if(data !=nil) {
                NSDictionary *json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:NSJSONReadingMutableContainers
                                      error:&error];
                NSLog(@"------JASON DATA BEGINS--->%@", json);
                
                if(error!=nil) {
                    NSLog(@"json error:%@", error);
                }
            }
        }

    }];
    [fetchWiki resume];

}



@end
