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
//    UINib *searchTermCells = [UINib nibWithNibName:@"ArticleView" bundle:nil];
//    [self.searchTableView registerNib:searchTermCells forCellReuseIdentifier:@"searchCell"];
    
    self.searchTableView.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

    self.bodyText.editable = NO;
    self.bodyText.text = @"";

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





//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    
//    __weak typeof(self) bruceBanner = self;
//    
//    [WikipediaAPI getArticleFor:searchBar.text completion:^(NSString *article) {
//        
//                         __strong typeof(bruceBanner) hulk = bruceBanner;
//        
//                         hulk.bodyText.text = article;
//                     }];
//}



//////////// DELEGATE METHODS \\\\\\\\\\\\\\\


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchTableView.hidden = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
//    return self.searchResultsArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    NSString *searchTerm = cell.textLabel.text;
    
//    self.searchResultsArray = [WikipediaAPI
    
//    cell.textLabel.text = self.searchResultsArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Test Cell"];
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"searchCell";
//    static NSString *CellNib = @"ArticleView";
//    
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        NSLog(@"----THE CELL IS NOT NIL-----");
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
//        cell = (UITableViewCell *)[nib objectAtIndex:0];
//    }
//    
//    cell.textLabel.text = self.searchResultsArray[indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"Test Cell"];
//    return cell;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *simpleTableIdentifier = @"searchCell";
//    
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ArticleView" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//        
////        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
//    
//    NSLog(@"%@", _searchResultsArray);
//    cell.textLabel.text = self.searchResultsArray[indexPath.row];
//    return cell;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) bruceBanner = self;
    
    [WikipediaAPI getArticleFor:_searchBar.text completion:^(NSString *article) {
        
        __strong typeof(bruceBanner) hulk = bruceBanner;
        
        hulk.bodyText.text = article;

    }];
}


@end
