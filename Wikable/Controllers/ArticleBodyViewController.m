//
//  ArticleBodyViewController.m
//  Wikable
//
//  Created by John D Hearn on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "ArticleBodyViewController.h"
#import "LoremIpsum.h"

@interface ArticleBodyViewController ()
//@property(strong, nonatomic)UIView * mainView;

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end

@implementation ArticleBodyViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.bodyLabel.text = kLoremIpsum;


}



@end
