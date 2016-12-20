//
//  WikipediaAPI.m
//  Wikable
//
//  Created by John Shaff on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

@import UIKit;
#import "WikipediaAPI.h"

NSString *kBaseURLforArticleFromAPI = @"https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&titles=";
NSString *kBaseURLforRawMarkup = @"http://en.wikipedia.org/w/index.php?action=raw&title=";
NSString *kBaseURLforTitleSearch = @"https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&utf8=&srsearch=";


@interface WikipediaAPI ()

@end


@implementation WikipediaAPI

// GRAB THE SEARCH BAR TEXT!!!
NSString *searchTerm = @"iphone 7";


+(void)getJSONfrom:(NSURL *)url
           success:(void (^)(NSDictionary *responseDict))success
           failure:(void(^)(NSError* error))failure {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *dataTask =
        [[NSURLSession sharedSession] dataTaskWithURL:url
                                    completionHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error) {
        if(error) {
            failure(error);
        } else {
            if(data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:nil];
                success(json);
            }
        }
    }];

    [dataTask resume];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

+(void)getRawMarkupfrom:(NSURL *)url
           success:(void (^)(NSData *data))success
           failure:(void(^)(NSError* error))failure {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *dataTask =
    [[NSURLSession sharedSession] dataTaskWithURL:url
                                completionHandler:^(NSData *data,
                                                    NSURLResponse *response,
                                                    NSError *error) {
        if(error) {
            failure(error);
        } else {
            if(data) {
                success(data);
            }
        }
    }];
    [dataTask resume];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

+(NSURL *)urlFrom:(NSString *)baseURL and:(NSString *)searchTerm {
    NSString *fixedTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *fixedTermWithBaseURL = [baseURL stringByAppendingString:fixedTerm];
    return [NSURL URLWithString:fixedTermWithBaseURL];
}

+(void)getArticleFrom:(NSString *)title
           completion:(void (^)(NSString *article))completion{

    NSURL *fullURL = [self urlFrom:kBaseURLforArticleFromAPI and:title];

    [self getJSONfrom:fullURL
              success:^(NSDictionary *responseDict) {
                  completion( responseDict[@"pages"]);
              }
              failure:^(NSError *error) {
                  NSLog(@"Failed to get Article: %@ \nError: %@", title, error);
              }];

}

+(void)getRawMarkupFrom:(NSString *)title
             completion:(void (^)(NSString *markup))completion {

    NSURL *fullURL = [self urlFrom:kBaseURLforRawMarkup and:title];

    [self getRawMarkupfrom:fullURL
                   success:^(NSData *data) {
                       completion((NSString *)data);
                   }
                   failure:^(NSError *error) {
                       NSLog(@"Failed to get Raw Markup: %@ \nError: %@", title, error);
                   }];


}


@end
