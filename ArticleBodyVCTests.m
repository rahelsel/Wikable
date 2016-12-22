//
//  ArticleBodyVCTests.m
//  Wikable
//
//  Created by Rachael A Helsel on 12/22/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ArticleBodyViewController.h"

@interface ArticleBodyVCTests : XCTestCase

@property(nonatomic) ArticleBodyViewController *articleBodyVCtest;

@end

@implementation ArticleBodyVCTests

- (void)setUp {
    [super setUp];
   
    self.articleBodyVCtest = [[ArticleBodyViewController alloc]init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testGetFakeArticle{
    
    NSAttributedString *testArticle = [self.articleBodyVCtest getFakeArticle];
    
    XCTAssertNotNil(testArticle, @"Test article was nil.");
    XCTAssertTrue([testArticle isKindOfClass:[NSAttributedString class]], @"Test article is not an attributed string.");


}

-(void)testConfigureView{

    

}




@end
