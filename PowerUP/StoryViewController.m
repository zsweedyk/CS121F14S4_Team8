//
//  StoryViewController.m
//  PowerUP
//
//  Created by Sean on 12/1/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "StoryViewController.h"
#import "LevelViewController.h"
#import <CoreText/CoreText.h>

@interface StoryViewController () {
    
    __weak IBOutlet UITextView *textView;
    __weak IBOutlet UIButton *next;
    
    NSDictionary *allText;
    NSDictionary *currentStateText;
    
    int totalPages;
    int currentPage;

}

@end

@implementation StoryViewController

# pragma mark - Initialization

/*
 * Called when view controller is displated. Sets up data members and the view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpDictionaries];
    [self setUpView];
    [self setUpText];

}

# pragma mark - Touch Events
/*
 * The method that is called when a User touches the next button.
 * Either displays more pages or segues to the level view controller
 */
- (IBAction)nextTouched:(id)sender {
    
    ++currentPage;
    
    if (currentPage > totalPages) {
        ++self.currentState;
        [self performSegueWithIdentifier:@"StoryToLevel" sender:self];
    } else {
        [self setUpText];
    }
    
}

#pragma mark - Helper Methods
/*
 * Sets the properties of the text view and next button
 */
- (void) setUpView {
    
    next.layer.borderColor = [UIColor grayColor].CGColor;
    next.layer.borderWidth = 2.0f;
    next.layer.cornerRadius = 10;
    
    textView.layer.borderColor = [UIColor yellowColor].CGColor;
    textView.layer.borderWidth = 5.0f;
    textView.layer.cornerRadius = 50;
}

/*
 * Reads in the property list and sets up dictionaries
 */
- (void) setUpDictionaries {
    
    NSString *plistPath  = [[NSBundle mainBundle] pathForResource:@"StoryText" ofType:@"plist"];
    allText = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    currentStateText = [[NSDictionary alloc] initWithDictionary:[allText objectForKey:[self getStateString]]];
    
    totalPages = [[currentStateText objectForKey:@"numPages"] intValue];
    currentPage = 0;
    
}

/*
 * Retreives and attributes the string that is to be displayed
 */
- (void) setUpText {
    
    NSString* textToDisplay = [self getProperText];
    NSAttributedString* displayReadyString = [self makeAttributedString:textToDisplay];
    
    textView.attributedText = displayReadyString;
}

/*
 * Retreives the right text given the currentpage from the dictionaries
 */
- (NSString*)getProperText {
    
    NSString* text = [currentStateText objectForKey:[NSString stringWithFormat:@"top%d",currentPage]];
    text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:[currentStateText objectForKey:[NSString stringWithFormat:@"middle%d",currentPage]]];
    text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:[currentStateText objectForKey:[NSString stringWithFormat:@"bottom%d",currentPage]]];
    
    return text;
}

/*
 * Adds the attributes to the string
 */
- (NSAttributedString*) makeAttributedString:(NSString*)stringToFormat {
    NSMutableAttributedString* displayReadyString = [[NSMutableAttributedString alloc] initWithString:stringToFormat];
    
    NSRange fullRange = NSMakeRange(0, stringToFormat.length);
    
    UIFont* font = [UIFont fontWithName:@"Helvetica Neue" size:36.0];
    [displayReadyString addAttribute:NSFontAttributeName value:font range:fullRange];
    
    [displayReadyString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:fullRange];
    
    NSMutableParagraphStyle* paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    [displayReadyString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:fullRange];
    
    return displayReadyString;
}

/*
 * Takes the enum type of the state we are in and returns a string of that enum type for dictionary keys
 */
- (NSString*) getStateString {
    
    NSString* state;
    switch (self.currentState) {
        case FIRST_TIME:
            state = @"FIRST_TIME";
            break;
            
        default:
            break;
    }
    
    return state;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"StoryToLevel"]) {
        LevelViewController* destViewController = [segue destinationViewController];
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
