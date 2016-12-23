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

@import Speech;




@interface ArticleBodyViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SFSpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *bodyText;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) MarkupParser *markupParser;


@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property(strong, nonatomic) NSArray *searchResultsArray;
@property (strong, nonatomic) SFSpeechRecognizer *speechRecognizer;
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (strong, nonatomic) SFSpeechRecognitionTask *recognitionTask;
@property (strong, nonatomic) AVAudioEngine *audioEngine;
@property (nonatomic) BOOL isSpeechRecognationAuthorized;


@end

@implementation ArticleBodyViewController



-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    UINib *searchTermCells = [UINib nibWithNibName:@"SearchCell" bundle:nil];
    [self.searchTableView registerNib:searchTermCells forCellReuseIdentifier:@"searchCell"];

    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.searchTableView.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        blurView.frame = self.searchTableView.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.searchTableView.backgroundView = blurView;
        //self.searchTableView.separatorEffect = [UIVibrancyEffect effectForBlurEffect:blur];
    } else {
        self.searchTableView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
    }

    self.searchTableView.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

    self.bodyText.editable = NO;
    self.bodyText.text = @""; //= [self getFakeArticle];

    self.markupParser = [MarkupParser shared];
    [self.markupParser linkifyArticle:@"iPhone"];

    //Speech-to-text stuff below
    self.isSpeechRecognationAuthorized = NO;
    self.speechRecognizer = [[SFSpeechRecognizer alloc]initWithLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en-US"]];
    self.speechRecognizer.delegate = self;
    self.audioEngine = [[AVAudioEngine alloc]init];
    [self requestSpeechRecognationAuthorization];


}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureView];
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




//MARK: DELEGATE METHODS


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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = searchBar.text;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResultsArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.textLabel.text = self.searchResultsArray[indexPath.row];
    //cell.textLabel.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
    cell.backgroundColor = [UIColor clearColor];

    cell.isAccessibilityElement = YES;
    cell.textLabel.isAccessibilityElement = YES;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"-----DID SELECT ROW------%@", _searchResultsArray);
    
    __weak typeof(self) bruceBanner = self;
    
    [WikipediaAPI getArticleFor: self.searchResultsArray[indexPath.row] completion:^(NSString *article) {
        __strong typeof(bruceBanner) hulk = bruceBanner;
        hulk.bodyText.text = article;
        hulk.searchTableView.hidden = YES;
        [hulk.searchBar endEditing:YES];
        hulk.searchBar.text = self.searchResultsArray[indexPath.row];
        
    }];
}



//MARK: Accessibility related functions

- (BOOL)accessibilityPerformMagicTap {
    [self searchBarDoubleTapped];
    NSLog(@"***Do some fancy magic here");
    return true;
}

//MARK: Speech-to-text related functions below

-(void) requestSpeechRecognationAuthorization {
    
    SFSpeechRecognizerAuthorizationStatus authStatus = [SFSpeechRecognizer authorizationStatus];

    if (authStatus == 3) {
        self.isSpeechRecognationAuthorized = true;
    } else {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            BOOL speechRecognitionStatus = false;
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    speechRecognitionStatus = true;
                    NSLog(@"***Speech Recognition Authorized");
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    NSLog(@"***Speech Recognition Status Not Detemined");
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    NSLog(@"***Speech Recognition Status Denied");
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    NSLog(@"***Speech Recognition Status Restricted");
                    break;

                default:
                    break;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                self.isSpeechRecognationAuthorized = speechRecognitionStatus;
            });

        }];
    }
}

-(void) searchBarDoubleTapped {
    if (self.isSpeechRecognationAuthorized) {
        if (self.audioEngine.isRunning) {
            [self.audioEngine stop];
            [self.recognitionRequest endAudio];

            self.searchTableView.hidden = NO;
            [WikipediaAPI getTitlesFor:self.searchBar.text
                            completion:^(NSArray * _Nonnull results) {
                                self.searchResultsArray = results;
                                [self.searchTableView reloadData];
                            }];
        } else {
            [self startRecording];
        }
    }
}

-(void) startRecording {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError;
    [session setCategory:AVAudioSessionCategoryRecord error:&setCategoryError];
    NSError *setModeError;
    [session setMode:AVAudioSessionModeMeasurement error:&setModeError];
    NSError *setActiveError;
    [session setActive:true error:&setActiveError];
    //setActive(true, with: .notifyOthersOnDeactivation)

    if (setCategoryError || setModeError ||  setActiveError) {
        return;
    }

    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    self.recognitionRequest.shouldReportPartialResults = true;

    if (!self.audioEngine.inputNode) {
        NSLog(@"***No Audio engine input node");
    }

    [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (error == nil) {
            if (result != nil ) {
                self.searchBar.text = [result bestTranscription].formattedString;

                if (result.isFinal){
                    [self.audioEngine stop];
                }
            }
        } else {
            //there is an error stop the audio
            [self.audioEngine stop];
        }
    }];


    if (self.audioEngine.inputNode) {
        AVAudioFormat *recordingFormat = [self.audioEngine.inputNode outputFormatForBus:0];

        [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
            [self.recognitionRequest appendAudioPCMBuffer:buffer];
        }];

    }

    [self.audioEngine prepare];

    NSError *audioStartError;
    [self.audioEngine startAndReturnError:&audioStartError];

    if (!audioStartError) {
        NSLog(@"***No Error from audio engine");
    } else {
        NSLog(@"***Can't start audio audio engine");
    }
    self.searchBar.text = @"Say something, I'm listening";
    
}



@end
