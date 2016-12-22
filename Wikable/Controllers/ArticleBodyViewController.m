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
