//
//  PHRoundedButton.h
//  PHRoundedButton
//
//  Created by Andrzej on 24/11/15.
//  Copyright © 2015 A&A.make LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PHRoundedButtonStyle) {
    PHRoundedButtonDefault,
    PHRoundedButtonSubtitle,
    PHRoundedButtonCentralImage,
    PHRoundedButtonImageWithTitle
};

extern CGFloat const PHRoundedButtonMaxValue;

@interface PHRoundedButton : UIControl

@property (readonly, nonatomic) PHRoundedButtonStyle         mr_buttonStyle;
@property (nonatomic, assign)   CGFloat                     cornerRadius;               //UI_APPEARANCE_SELECTOR
@property (nonatomic, assign)   CGFloat                     borderWidth;                //UI_APPEARANCE_SELECTOR
@property (nonatomic, strong)   UIColor                     *borderColor;               //UI_APPEARANCE_SELECTOR
@property (nonatomic, strong)   UIColor                     *contentColor;              //UI_APPEARANCE_SELECTOR
@property (nonatomic, strong)   UIColor                     *foregroundColor;           //UI_APPEARANCE_SELECTOR
@property (nonatomic, strong)   UIColor                     *borderAnimateToColor;      //UI_APPEARANCE_SELECTOR
@property (nonatomic, strong)   UIColor                     *contentAnimateToColor;     //UI_APPEARANCE_SELECTOR
@property (nonatomic, strong)   UIColor                     *foregroundAnimateToColor;  //UI_APPEARANCE_SELECTOR
@property (nonatomic, assign)   BOOL                        restoreSelectedState;       //UI_APPEARANCE_SELECTOR

@property (nonatomic, weak)     UILabel                     *textLabel;
@property (nonatomic, weak)     UILabel                     *detailTextLabel;
@property (nonatomic, weak)     UIImageView                 *imageView;
@property (nonatomic, assign)   UIEdgeInsets                contentEdgeInsets;

/////
//new - do this with layer aswell
@property (nonatomic, weak) UIImageView *backgroundImageView;
/////

+ (instancetype)buttonWithFrame:(CGRect)frame
                    buttonStyle:(PHRoundedButtonStyle)style
           appearanceIdentifier:(NSString *)identifier;
- (instancetype)initWithFrame:(CGRect)frame
                  buttonStyle:(PHRoundedButtonStyle)style;
- (instancetype)initWithFrame:(CGRect)frame
                  buttonStyle:(PHRoundedButtonStyle)style
         appearanceIdentifier:(NSString *)identifier;

@end


extern NSString *const kPHRoundedButtonCornerRadius;
extern NSString *const kPHRoundedButtonBorderWidth;
extern NSString *const kPHRoundedButtonBorderColor;
extern NSString *const kPHRoundedButtonContentColor;
extern NSString *const kPHRoundedButtonForegroundColor;
extern NSString *const kPHRoundedButtonBorderAnimateToColor;
extern NSString *const kPHRoundedButtonContentAnimateToColor;
extern NSString *const kPHRoundedButtonForegroundAnimateToColor;
extern NSString *const kPHRoundedButtonRestoreSelectedState;

@interface PHRoundedButtonAppearanceManager : NSObject

+ (void)registerAppearanceProxy:(NSDictionary *)proxy forIdentifier:(NSString *)identifier;
+ (void)unregisterAppearanceProxyIdentier:(NSString *)identifier;
+ (NSDictionary *)appearanceForIdentifier:(NSString *)identifier;

@end

//@interface MRHollowBackgroundView : UIView
//
//@property (nonatomic, strong)   UIColor *foregroundColor;
//
//@end
