//
//  WikipediaAPITest.m
//  Wikable
//
//  Created by Rachael A Helsel on 12/22/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WikipediaAPI.h"

@interface WikipediaAPITest : XCTestCase

@property(nonatomic) WikipediaAPI *wikipediaAPItest;

@end

@implementation WikipediaAPITest

- (void)setUp {
    [super setUp];

    self.wikipediaAPItest = [[WikipediaAPI alloc]init];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testURLfrom{

    NSString *testString1 = @"http://www.preeminent.org/steve/iOSTutorials/XCTest/";
    NSString *testString2 = @" Siamese Cat ";
    NSURL *testNSURL = [WikipediaAPI urlFrom:testString1 and:testString2];

    NSLog(@"%@", testNSURL.absoluteString);
    
    XCTAssertTrue(![testNSURL.absoluteString containsString:@" "], @"Still contains space character.");
}

@end
