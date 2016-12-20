//
//  WikipediaAPI.h
//  Wikable
//
//  Created by John Shaff on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikipediaAPI : NSObject


+(void)getArticleFrom:(NSString *)title
           completion:(void (^)(NSString *article))completion;

+(NSURL *)urlFrom:(NSString *)baseURL
              and:(NSString *)searchTerm;

@end
