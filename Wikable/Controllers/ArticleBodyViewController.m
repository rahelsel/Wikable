//
//  ArticleBodyViewController.m
//  Wikable
//
//  Created by John D Hearn on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "ArticleBodyViewController.h"
#import "WikipediaAPI.h"
#import "LoremIpsum.h"


@interface ArticleBodyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *bodyText;


@end

@implementation ArticleBodyViewController



-(void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

    self.bodyText.text = @"";
    __weak typeof(self) bruceBanner = self;

    [WikipediaAPI getArticleFor:@"iPhone"
                     completion:^(NSString *article) {
                         //NSLog(@"%@", article);
                         __strong typeof(bruceBanner) hulk = bruceBanner;
                         hulk.bodyText.text = article;
                     }];


//    self.bodyText.text = kLoremIpsum;
    self.bodyText.editable = NO;


//    [WikipediaAPI getRawMarkupFor:@"iPhone"
//                       completion:^(NSString *markup) {
//                           NSLog(@"%@", markup);
//                       }];
//    [WikipediaAPI getTitlesFor:@"iPhone"
//                    completion:^(NSArray *titles) {
//                        NSLog(@"%@", titles);
//                    }];
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
    //UIFont *myFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    self.bodyText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
