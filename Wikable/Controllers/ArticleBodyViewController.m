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




@interface ArticleBodyViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *bodyText;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) MarkupParser *markupParser;

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property(strong, nonatomic) NSArray *searchResultsArray;


@end

@implementation ArticleBodyViewController



-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    UINib *searchTermCells = [UINib nibWithNibName:@"SearchCell" bundle:nil];
    [self.searchTableView registerNib:searchTermCells forCellReuseIdentifier:@"searchCell"];
    
    self.searchTableView.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

    self.bodyText.editable = NO;
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
    self.bodyText.attributedText = [self getFakeArticle];
}

-(NSAttributedString *)getFakeArticle{

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
    NSMutableAttributedString *article = [[NSMutableAttributedString alloc] initWithAttributedString:headline1];

    [article appendAttributedString:body1];
    [article appendAttributedString:headline2];
    [article appendAttributedString:body2];

    article.accessibilityTraits = UIAccessibilityTraitHeader;

    return article;
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self configureView];
}


- (void)configureView
{
    NSLog(@"%@", [[UIApplication sharedApplication] preferredContentSizeCategory] );
    UIFont *myFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    self.bodyText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




//////////// DELEGATE METHODS \\\\\\\\\\\\\\\


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchBar.text isEqualToString: @""]) {
        self.searchTableView.hidden = YES;
    } else {
    self.searchTableView.hidden = NO;
    }
    
    NSString *searchTerm = self.searchBar.text;
    
    [WikipediaAPI getTitlesFor:searchTerm
                    completion:^(NSArray * _Nonnull results) {
                        
                        self.searchResultsArray = results;
                        [self.searchTableView reloadData];
                    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResultsArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.textLabel.text = self.searchResultsArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"-----DID SELECT ROW------%@", _searchResultsArray);
    
    __weak typeof(self) bruceBanner = self;
    
    [WikipediaAPI getArticleFor: self.searchResultsArray[indexPath.row] completion:^(NSString *article) {
        
        __strong typeof(bruceBanner) hulk = bruceBanner;
        
        hulk.bodyText.text = article;
        
        hulk.searchTableView.hidden = YES;
        
    }];
}



@end
