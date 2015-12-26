//
//  ViewController.m
//  PHRoundedButton
//
//  Created by Andrzej on 24/11/15.
//  Copyright © 2015 A&A.make LTD. All rights reserved.
//

#import "ViewController.h"
#import "PHRoundedButton.h"
#import "UIImageView+LBBlurredImage.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSDictionary *appearanceProxy1 = @{kPHRoundedButtonCornerRadius : @50,
                                       kPHRoundedButtonBorderWidth  : @2,
                                       kPHRoundedButtonBorderColor  : [[UIColor blackColor] colorWithAlphaComponent:0.6],
                                       kPHRoundedButtonBorderAnimateToColor  : [UIColor clearColor],
                                       kPHRoundedButtonContentColor : [UIColor blackColor],
                                       kPHRoundedButtonContentAnimateToColor : [UIColor whiteColor],
                                       kPHRoundedButtonForegroundColor : [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                                       kPHRoundedButtonForegroundAnimateToColor : [UIColor clearColor]};
    
    NSDictionary *appearanceProxy2 = @{kPHRoundedButtonCornerRadius : @25,
                                       kPHRoundedButtonBorderWidth  : @1.5,
                                       kPHRoundedButtonRestoreSelectedState : @NO,
                                       kPHRoundedButtonBorderColor : [[UIColor blackColor] colorWithAlphaComponent:0.5],
                                       kPHRoundedButtonBorderAnimateToColor : [UIColor whiteColor],
                                       kPHRoundedButtonContentColor : [[UIColor blackColor] colorWithAlphaComponent:0.5],
                                       kPHRoundedButtonContentAnimateToColor : [UIColor whiteColor],
                                       kPHRoundedButtonForegroundColor : [[UIColor whiteColor] colorWithAlphaComponent:0.5]};
    
    NSDictionary *appearanceProxy3 = @{
                                       kPHRoundedButtonCornerRadius : @50,
                                       kPHRoundedButtonBorderWidth  : @2,
                                       kPHRoundedButtonRestoreSelectedState : @NO,
                                       kPHRoundedButtonBorderColor : [UIColor grayColor],
                                       kPHRoundedButtonBorderAnimateToColor : [UIColor darkGrayColor],
                                       kPHRoundedButtonContentColor : [UIColor orangeColor],
                                       kPHRoundedButtonContentAnimateToColor : [UIColor redColor],
                                       kPHRoundedButtonForegroundColor : [[UIColor blackColor] colorWithAlphaComponent:0.5],
                                       kPHRoundedButtonForegroundAnimateToColor : [[UIColor whiteColor] colorWithAlphaComponent:0.8]
                                       };
    
    [PHRoundedButtonAppearanceManager registerAppearanceProxy:appearanceProxy1 forIdentifier:@"1"];
    [PHRoundedButtonAppearanceManager registerAppearanceProxy:appearanceProxy2 forIdentifier:@"2"];
    [PHRoundedButtonAppearanceManager registerAppearanceProxy:appearanceProxy3 forIdentifier:@"3"];
    
    
    /////////////////////////////////////////////////////////////////////////////
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImageToBlur:[UIImage imageNamed:@"pic"] completionBlock:NULL];
    [self.view addSubview:imageView];
    
    CGFloat backgroundViewHeight = ceilf(CGRectGetHeight([UIScreen mainScreen].bounds)/ 3.0);
    CGFloat backgroundViewWidth = CGRectGetWidth(self.view.bounds);
    
    NSArray *buttonStyleArray = @[@(PHRoundedButtonSubtitle),
                                  @(PHRoundedButtonCentralImage),
                                  @(PHRoundedButtonDefault)];
    
    for (int i = 0; i < 3; i++) {
        CGRect backgroundRect = CGRectMake(0,
                                           backgroundViewHeight * i,
                                           backgroundViewWidth,
                                           backgroundViewHeight);
        
        CGFloat buttonSize = i == 1 ? 50 : 100;
        
        CGRect buttonRect = CGRectMake((backgroundViewWidth - buttonSize) / 2.0,
                                       (backgroundViewHeight - buttonSize) / 2.0 + backgroundRect.origin.y,
                                       buttonSize,
                                       buttonSize);
        
        PHRoundedButton *button = [[PHRoundedButton alloc] initWithFrame:buttonRect buttonStyle:[buttonStyleArray[i] integerValue]
                                                  appearanceIdentifier:[NSString stringWithFormat:@"%d", i + 1]];
        
        button.backgroundColor = [UIColor clearColor];
        
        if (i == 0) {
            button.backgroundImageView.image = [UIImage imageNamed:@"pic"];
            button.textLabel.text = @"A";
            button.textLabel.font = [UIFont boldSystemFontOfSize:50];
            button.detailTextLabel.text = @"Alternative";
            button.detailTextLabel.font = [UIFont systemFontOfSize:10];
            
        } else if(i == 1) {
            button.backgroundImageView.image = [UIImage imageNamed:@"pic"];
            button.imageView.image = [UIImage imageNamed:@"twitter"];
            button.textLabel.text = @"A";
            button.textLabel.font = [UIFont boldSystemFontOfSize:30];
            button.detailTextLabel.text = @"Alternative";
            button.detailTextLabel.font = [UIFont systemFontOfSize:10];
            
        }  else if(i == 2) {
            button.backgroundImageView.image = [UIImage imageNamed:@"pic"];
            button.textLabel.text = @"A";
            button.textLabel.font = [UIFont boldSystemFontOfSize:30];
        }

        [self.view addSubview:button];
    }
    
}


@end
