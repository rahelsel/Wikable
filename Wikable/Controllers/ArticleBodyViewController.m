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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollSubView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@end

@implementation ArticleBodyViewController



-(void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

    self.bodyLabel.text = kLoremIpsum;

    UIFont *myFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];


    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureView];
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self configureView];
}


- (void)configureView
{
    NSLog(@"%@", [[UIApplication sharedApplication] preferredContentSizeCategory] );
    self.bodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
