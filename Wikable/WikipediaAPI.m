//
//  WikipediaAPI.m
//  Wikable
//
//  Created by John Shaff on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

@import UIKit;
#import "WikipediaAPI.h"

static NSString *kBaseURLforArticleFromAPI = @"https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&titles=";
static NSString *kBaseURLforRawMarkup = @"http://en.wikipedia.org/w/index.php?action=raw&title=";
static NSString *kBaseURLforTitleSearch = @"https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&utf8=&srsearch=";

@interface WikipediaAPI ()

@end


@implementation WikipediaAPI

+(void)getContentsOf:(NSURL *) url
             success:(void (^)(NSData *data))success
             failure:(void(^)(NSError* error))failure {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *dataTask =
    [[NSURLSession sharedSession] dataTaskWithURL:url
                                completionHandler:^(NSData *data,
                                                    NSURLResponse *response,
                                                    NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if(error) {
                failure(error);
            } else {
                if(data) {
                    success(data);
                }
            }
        }];

    }];
    [dataTask resume];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

+(NSURL *)urlFrom:(NSString *)baseURL and:(NSString *)searchTerm {
    NSString *fixedTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *fixedTermWithBaseURL = [baseURL stringByAppendingString:fixedTerm];
    return [NSURL URLWithString:fixedTermWithBaseURL];
}

+(void)getArticleFor:(NSString * _Nonnull)title
          completion:(nullable void (^)(NSString * _Nonnull article))completion{

    NSURL *fullURL = [self urlFrom:kBaseURLforArticleFromAPI and:title];

    [self getContentsOf:fullURL
                success:^(NSData *data) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];

                    NSString *articleID = [[json[@"query"][@"pages"] allKeys] firstObject];
                    completion( json[@"query"][@"pages"][articleID][@"extract"]);
                }
                failure:^(NSError *error) {
                    NSLog(@"Failed to get Article: %@ \nError: %@", title, error);
                }];

}

+(void)getRawMarkupFor:(NSString * _Nonnull)title completion:(nullable void (^)(NSString * _Nonnull markup))completion {

    NSURL *fullURL = [self urlFrom:kBaseURLforRawMarkup and:title];

    [self getContentsOf:fullURL
               success:^(NSData *data) {
                        NSString *stringified = [[NSString alloc] initWithData:data
                                                                      encoding:NSUTF8StringEncoding];
                        completion(stringified);
               }
               failure:^(NSError *error) {
                   NSLog(@"Failed to get Raw Markup: %@ \nError: %@", title, error);
               }];
}

+(void)getTitlesFor:(NSString * _Nonnull)searchTerm completion:(nullable void (^)(NSArray * _Nonnull titles))completion {

    NSURL *fullURL = [self urlFrom:kBaseURLforTitleSearch and:searchTerm];

    [self getContentsOf:fullURL
                success:^(NSData *data) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                    NSArray *arr = json[@"query"][@"search"];
                    completion( [arr valueForKey: @"title"] );
                    
                }
                failure:^(NSError *error) {
                    NSLog(@"Failed to get results for searth term: %@ \nError: %@", searchTerm, error);
                }];


}

@end
