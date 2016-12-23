//
//  WikipediaAPI.h
//  Wikable
//
//  Created by John Shaff on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikipediaAPI : NSObject


+(void)getArticleFor:(NSString * _Nonnull)title
          completion:(nullable void (^)(NSString * _Nonnull article))completion;

+(void)getRawMarkupFor:(NSString *_Nonnull )title
            completion:(nullable void (^)(NSString * _Nonnull markup))completion;

+(void)getTitlesFor:(NSString * _Nonnull)searchTerm
         completion:(nullable void (^)(NSArray * _Nonnull results))completion;

@end
