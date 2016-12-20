//
//  WikipediaAPI.h
//  Wikable
//
//  Created by John Shaff on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikipediaAPI : NSObject


+(void)getArticleFor:(NSString *)title
          completion:(void (^)(NSString *article))completion;

+(void)getRawMarkupFor:(NSString *)title
            completion:(void (^)(NSString *markup))completion;

+(void)getTitlesFor:(NSString *)searchTerm
         completion:(void (^)(NSArray *results))completion;

@end
