//
//  ArticleBodyViewController.m
//  Wikable
//
//  Created by John D Hearn on 12/19/16.
//  Copyright © 2016 Bastardized Productions. All rights reserved.
//

#import "ArticleBodyViewController.h"
#import "Wikable-Swift.h"
#import "WikipediaAPI.h"




@interface ArticleBodyViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;


@property (strong, nonatomic) MarkupParser *markupParser;
@end

@implementation ArticleBodyViewController



-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

    //TODO: fix this
    //self.bodyText.editable = NO;
    //self.bodyText.text = [self getFakeArticle];  //@"";

    self.markupParser = [MarkupParser shared];
    [self.markupParser linkifyArticle:@"iPhone"];

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
    [self getFakeArticle];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    NSLog(@"LayoutSubviews happened");
//    NSLog(@"svFrameHeight: %f \ncontainerHeight: %f",
//          self.scrollView.frame.size.height,
//          self.containerView.frame.size.height);
    //self.scrollView.contentSize = CGSizeMake(self.containerView.frame.size.width, self.containerView.frame.size.height);
}

-(void)getFakeArticle{

    UIFont *bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    UIFont *headlineFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

    NSString *lorem = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean bibendum ipsum lobortis ligula maximus lobortis. Maecenas laoreet nibh ligula, ut interdum metus rhoncus quis. Pellentesque finibus dapibus ipsum, sit amet porta lacus finibus at. In et lorem eleifend, aliquam lorem a, ultrices mi. Sed iaculis pretium pretium. Suspendisse potenti. Vestibulum condimentum cursus nulla, ut facilisis nisl congue sed. Mauris in commodo magna. Nulla vulputate at mi sed laoreet. Morbi dapibus tempor pellentesque. Mauris tincidunt sapien ipsum, id convallis sem efficitur vitae.\n\n";

    NSString *ipsum = @"Ut hendrerit interdum risus eget tincidunt. Cras eget auctor metus. Proin nec malesuada diam, eu iaculis nulla. Integer eu lacinia lorem, in vulputate neque. Suspendisse non blandit eros. Aliquam luctus aliquam finibus. Ut molestie ut mauris eget semper. Aliquam viverra dui odio, sit amet blandit enim mollis a. Cras sollicitudin dolor ut commodo porta. Nullam felis eros, porttitor et aliquet at, egestas non mi. Integer venenatis lorem sed tellus maximus, tincidunt tristique odio tempus. Sed urna massa, fringilla vel faucibus vitae, ullamcorper non libero. Praesent vel lacus in ipsum tempor fermentum. Praesent nisl nulla, laoreet nec lacus nec, volutpat sodales nisl. Praesent consectetur, mauris eu pharetra fermentum, nunc nisi commodo est, in consectetur sapien nunc vulputate nulla.\n\n";



    NSAttributedString *headline1 = [[NSAttributedString alloc] initWithString:@"Headline 1\n\n"
                                                                  attributes:@{NSFontAttributeName: headlineFont}];
    NSAttributedString *headline2 = [[NSAttributedString alloc] initWithString:@"Headline 2\n\n"
                                                                  attributes:@{NSFontAttributeName: headlineFont}];

    headline1.accessibilityTraits = UIAccessibilityTraitHeader;
    headline2.accessibilityTraits = UIAccessibilityTraitHeader;

    NSAttributedString *body1 = [[NSAttributedString alloc] initWithString:lorem
                                                                attributes:@{NSFontAttributeName: bodyFont}];

    NSAttributedString *body2 = [[NSAttributedString alloc] initWithString:ipsum
                                                                attributes:@{NSFontAttributeName: bodyFont}];
    NSMutableAttributedString *section1 = [[NSMutableAttributedString alloc] initWithAttributedString:headline1];
    [section1 appendAttributedString:body1];
    NSMutableAttributedString *section2 = [[NSMutableAttributedString alloc] initWithAttributedString:headline2];
    [section2 appendAttributedString:body2];

    //article.accessibilityTraits = UIAccessibilityTraitHeader;

//    self.bodyText.attributedText = headline1;
//    self.bodyText.attributedText.accessibilityTraits = UIAccessibilityTraitHeader;
//    self.bodyText.isAccessibilityElement = YES;
//    self.bodyText.accessibilityTraits = UIAccessibilityTraitHeader;
//    self.textview2.attributedText = body1;
//    self.textview3.attributedText = headline2;
//    self.textview3.attributedText.accessibilityTraits = UIAccessibilityTraitHeader;
//    self.textview3.isAccessibilityElement = YES;
//    self.textview3.accessibilityTraits = UIAccessibilityTraitHeader;
//    self.textview4.attributedText = body2;


//    CGRect frame = self.containerView.frame;
//    frame.size.height = 300.0;
//
//    UITextView *textView1 = [[UITextView alloc] init];
//    textView1.frame = frame;
//    textView1.attributedText = section1;
//    textView1.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
//
//
//    UITextView *textView2 = [[UITextView alloc] init];
//    textView2.attributedText = section2;
//    textView2.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
//    textView2.frame = frame;
//    CGRect frame2 = CGRectMake(0.0, textView1.frame.size.height + 10., textView1.frame.size.width, 300.0);
//    textView2.frame = frame2;
//
//    [self.containerView addSubview:textView1];
//    [self.containerView addSubview:textView2];
//    textView1.scrollEnabled = NO;
//    textView2.scrollEnabled = NO;
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];

    [self layoutTextViews:@[headline1, body1, headline2, body2]];
}

-(void)layoutTextViews:(NSArray *)views{
    CGFloat pad = 0.0;
    CGFloat offset = 0.0;
    UIFont *headlineFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

    for (NSAttributedString* text in views) {
        NSRange rangeOfOne = NSMakeRange(0, 1);
        CGRect textSize = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.containerView.frame), MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];

        CGRect frame = CGRectMake(textSize.origin.x,
                                  textSize.origin.y + offset,
                                  CGRectGetWidth(self.containerView.frame),
                                  textSize.size.height);
        offset += frame.size.height + pad;

        //NSLog(@"size: %f, %f", textSize.size.height, textSize.size.width);

        UITextView *textView = [[UITextView alloc] init];
        textView.frame = frame;
        textView.attributedText = text;
        textView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
        textView.scrollEnabled = NO;

        NSDictionary *attributes = [text attributesAtIndex:0 effectiveRange:&rangeOfOne];
        if([attributes valueForKey:@"NSFont"] == headlineFont){
            textView.accessibilityTraits = UIAccessibilityTraitHeader;
        }


        [self.containerView addSubview:textView];

    }
    NSLog(@"Font: %@", headlineFont);
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self configureView];
}


- (void)configureView
{
    NSLog(@"%@", [[UIApplication sharedApplication] preferredContentSizeCategory] );
    UIFont *myFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    //TODO: fix this
    //self.bodyText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    __weak typeof(self) bruceBanner = self;
    [WikipediaAPI getArticleFor:searchBar.text
                     completion:^(NSString *article) {
                         
                         __strong typeof(bruceBanner) hulk = bruceBanner;
                         //TODO: fix this
                         //hulk.bodyText.text = article;
                     }];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
