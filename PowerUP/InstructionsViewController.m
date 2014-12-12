//
//  InstructionsViewController.m
//  PowerUP
//
//  Created by Daniel Cogan on 12/8/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "InstructionsViewController.h"
#import "MenuViewController.h"
#import <CoreText/CoreText.h>

@interface InstructionsViewController () {
    
    __weak IBOutlet UITextView *textView;
    __weak IBOutlet UIButton *next;
    
    NSDictionary *allText;
    
    int totalPages;
    int currentPage;
}

@end

@implementation InstructionsViewController

# pragma mark - Initialization

/*
 * Called when view controller is displated. Sets up data members and the view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"instructions1.png"]]];
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
    NSString* bgImage = [@"instructions" stringByAppendingString:[NSString stringWithFormat:@"%d", currentPage]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:bgImage]]];
    
    if (currentPage > totalPages) {
        [self performSegueWithIdentifier:@"InstructionsToMenu" sender:self];
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
    [next setTitle:[allText objectForKey:@"Next"] forState:UIControlStateNormal];
    
    textView.layer.borderColor = [UIColor yellowColor].CGColor;
    textView.layer.borderWidth = 5.0f;
    textView.layer.cornerRadius = 50;
}

/*
 * Reads in the property list and sets up dictionaries
 */
- (void) setUpDictionaries {
    NSString *plistPath;
    switch (self.mainLanguage) {
        case ENGLISH:
            plistPath  = [[NSBundle mainBundle] pathForResource:@"InstructionsText" ofType:@"plist"];
            break;
            
        case SPANISH:
            plistPath  = [[NSBundle mainBundle] pathForResource:@"InstructionsTextSpanish" ofType:@"plist"];
            break;
            
        case CHINESE:
            plistPath  = [[NSBundle mainBundle] pathForResource:@"InstructionsTextChinese" ofType:@"plist"];
            break;
            
        default:
            break;
    }
    
    allText = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    totalPages = [[allText objectForKey:@"numPages"] intValue];
    currentPage = 1;
    
    
}

/*
 * Retreives and attributes the string that is to be displayed
 */
- (void) setUpText {
    
    NSString *textToDisplay = [self getProperText];
    NSAttributedString *displayReadyString = [self makeAttributedString:textToDisplay];
    
    textView.attributedText = displayReadyString;
}

/*
 * Retreives the right text given the currentpage from the dictionaries
 */
- (NSString*)getProperText {
    
    NSString *text = [allText objectForKey:[NSString stringWithFormat:@"top%d",currentPage]];
    text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:[allText objectForKey:[NSString stringWithFormat:@"middle%d",currentPage]]];
    text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:[allText objectForKey:[NSString stringWithFormat:@"bottom%d",currentPage]]];
    
    return text;
}

/*
 * Adds the attributes to the string
 */
- (NSAttributedString*) makeAttributedString:(NSString*)stringToFormat {
    NSMutableAttributedString* displayReadyString = [[NSMutableAttributedString alloc] initWithString:stringToFormat];
    
    NSRange fullRange = NSMakeRange(0, stringToFormat.length);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:36.0];
    [displayReadyString addAttribute:NSFontAttributeName value:font range:fullRange];
    
    [displayReadyString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:fullRange];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    [displayReadyString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:fullRange];
    
    return displayReadyString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"InstructionsToMenu"]) {
        MenuViewController *destViewController = [segue destinationViewController];
        destViewController.mainLanguage = self.mainLanguage;
        destViewController.currentState = self.currentState;
        destViewController.locks = self.locks;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
