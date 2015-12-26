//
//  PHRoundedButton.m
//  PHRoundedButton
//
//  Created by Andrzej on 24/11/15.
//  Copyright © 2015 A&A.make LTD. All rights reserved.
//


#import "PHRoundedButton.h"
#import <QuartzCore/QuartzCore.h>


CGFloat const PHRoundedButtonMaxValue = CGFLOAT_MAX;


#define M_MAX_CORNER_RADIUS MIN(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
#define M_MAX_BORDER_WIDTH  M_MAX_CORNER_RADIUS
#define M_MAGICAL_VALUE     0.29


#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif


#pragma mark - CGRect extend
static CGRect CGRectEdgeInset(CGRect rect, UIEdgeInsets insets)
{
    return CGRectMake(CGRectGetMinX(rect) + insets.left, CGRectGetMinY(rect) + insets.top, CGRectGetWidth(rect) - insets.left - insets.right, CGRectGetHeight(rect) - insets.top - insets.bottom);
}


///////////////////////////
#pragma mark - MRTextLayer

@interface MRTextLayer : UIView
@property (nonatomic, strong) UILabel *textLabel;
@end


@implementation MRTextLayer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.minimumScaleFactor = 0.1;
        self.textLabel.numberOfLines = 1;
        self.layer.mask = self.textLabel.layer;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}

@end

///////////////////////////
#pragma mark - MRImageLayer

@interface MRImageLayer : UIView
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation MRImageLayer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor clearColor];
        self.layer.mask = self.imageView.layer;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end


//////////////////////////////
#pragma mark - PHRoundedButton


@interface PHRoundedButton ()

@property (nonatomic, strong) UIColor *backgroundColorCache;
@property (assign, getter = isTrackingInside) BOOL trackingInside;
@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, strong) MRTextLayer *textLayer;
@property (nonatomic, strong) MRTextLayer *detailTextLayer;
@property (nonatomic, strong) MRImageLayer *imageLayer;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end


@implementation PHRoundedButton

@synthesize backgroundImageView = _backgroundImageView;

- (instancetype)initWithFrame:(CGRect)frame buttonStyle:(PHRoundedButtonStyle)style appearanceIdentifier:(NSString *)identifier
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        
        _ph_buttonStyle = style;
        _contentColor = self.tintColor;
        _foregroundColor = [UIColor whiteColor];
        _restoreSelectedState = YES;
        _trackingInside = NO;
        _cornerRadius = 0.0;
        _borderWidth = 0.0;
        _contentEdgeInsets = UIEdgeInsetsZero;
        
        self.foregroundView = [[UIView alloc] initWithFrame:CGRectNull];
        self.foregroundView.backgroundColor = self.foregroundColor;
        self.foregroundView.layer.masksToBounds = YES;
        [self addSubview:self.foregroundView];
        
        self.textLayer = [[MRTextLayer alloc] initWithFrame:CGRectNull];
        self.textLayer.backgroundColor = self.contentColor;
        [self insertSubview:self.textLayer aboveSubview:self.foregroundView];
        
        self.detailTextLayer = [[MRTextLayer alloc] initWithFrame:CGRectNull];
        self.detailTextLayer.backgroundColor = self.contentColor;
        [self insertSubview:self.detailTextLayer aboveSubview:self.foregroundView];
        
        self.imageLayer = [[MRImageLayer alloc] initWithFrame:CGRectNull];
        self.imageLayer.backgroundColor = self.contentColor;
        [self insertSubview:self.imageLayer aboveSubview:self.foregroundView];
        
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectNull];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self insertSubview:self.backgroundImageView belowSubview:self.foregroundView];
        
        [self applyAppearanceForIdentifier:identifier];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame buttonStyle:(PHRoundedButtonStyle)style
{
    return [[PHRoundedButton alloc] initWithFrame:frame buttonStyle:style appearanceIdentifier:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [[PHRoundedButton alloc] initWithFrame:frame buttonStyle:PHRoundedButtonDefault appearanceIdentifier:nil];
}

+ (instancetype)buttonWithFrame:(CGRect)frame buttonStyle:(PHRoundedButtonStyle)style appearanceIdentifier:(NSString *)identifier
{
    return [[PHRoundedButton alloc] initWithFrame:frame buttonStyle:style appearanceIdentifier:identifier];
}

- (CGRect)boxingRect
{
    CGRect internalRect = CGRectInset(self.bounds,  self.layer.cornerRadius * M_MAGICAL_VALUE + self.layer.borderWidth, self.layer.cornerRadius * M_MAGICAL_VALUE + self.layer.borderWidth);
    return CGRectEdgeInset(internalRect, self.contentEdgeInsets);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cornerRadius = self.layer.cornerRadius = MAX(MIN(M_MAX_CORNER_RADIUS, self.cornerRadius), 0);
    CGFloat borderWidth = self.layer.borderWidth = MAX(MIN(M_MAX_BORDER_WIDTH, self.borderWidth), 0);
    
    _borderWidth = borderWidth;
    _cornerRadius = cornerRadius;
    
    CGFloat layoutBorderWidth = borderWidth == 0.0 ? 0.0 : borderWidth - 0.1;
    self.foregroundView.frame = CGRectMake(layoutBorderWidth, layoutBorderWidth, CGRectGetWidth(self.bounds) - layoutBorderWidth * 2, CGRectGetHeight(self.bounds) - layoutBorderWidth * 2);
    
    self.foregroundView.layer.cornerRadius = cornerRadius - borderWidth;
    
    self.backgroundImageView.frame = CGRectMake(layoutBorderWidth, layoutBorderWidth, CGRectGetWidth(self.bounds) - layoutBorderWidth * 2, CGRectGetHeight(self.bounds) - layoutBorderWidth * 2);;


    switch (self.ph_buttonStyle) {
        case PHRoundedButtonDefault: {
            self.imageLayer.frame = CGRectNull;
            self.detailTextLayer.frame = CGRectNull;
            self.textLayer.frame = [self boxingRect];
            break;
        }
            
        case PHRoundedButtonSubtitle: {
            self.imageLayer.frame = CGRectNull;
            CGRect boxRect = [self boxingRect];
            self.textLayer.frame = CGRectMake(boxRect.origin.x,
                                              boxRect.origin.y,
                                              CGRectGetWidth(boxRect),
                                              CGRectGetHeight(boxRect) * 0.8);
            self.detailTextLayer.frame = CGRectMake(boxRect.origin.x,
                                                    CGRectGetMaxY(self.textLayer.frame),
                                                    CGRectGetWidth(boxRect),
                                                    CGRectGetHeight(boxRect) * 0.2);
            break;
        }
            
        case PHRoundedButtonCentralImage: {
            self.textLayer.frame = CGRectNull;
            self.detailTextLayer.frame = CGRectNull;
            self.imageLayer.frame = [self boxingRect];
            break;
        }
            
        case PHRoundedButtonImageWithSubtitle:
            
        default: {
            CGRect boxRect = [self boxingRect];
            self.textLayer.frame = CGRectNull;
            self.imageLayer.frame = CGRectMake(boxRect.origin.x,
                                               boxRect.origin.y,
                                               CGRectGetWidth(boxRect),
                                               CGRectGetHeight(boxRect) * 0.8);
            self.detailTextLayer.frame = CGRectMake(boxRect.origin.x,
                                                    CGRectGetMaxY(self.imageLayer.frame),
                                                    CGRectGetWidth(boxRect),
                                                    CGRectGetHeight(boxRect) * 0.2);
            break;
        }
    }
}


#pragma mark - Appearance

- (void)setAppearanceIdentifier:(NSString *)identifier
{
    [self applyAppearanceForIdentifier:identifier];
}

- (void)applyAppearanceForIdentifier:(NSString *)identifier
{
    if (![identifier length])
        return;
    
    NSDictionary *appearanceProxy = [PHRoundedButtonAppearanceManager appearanceForIdentifier:identifier];
    if (!appearanceProxy)
        return;
    
    [appearanceProxy enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key];
    }];
}

#pragma mark - Setter and getters
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius)
        return;
    
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    if (_borderWidth == borderWidth)
        return;
    
    _borderWidth = borderWidth;
    [self setNeedsLayout];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setContentColor:(UIColor *)contentColor
{
    _contentColor = contentColor;
    self.textLayer.backgroundColor = contentColor;
    self.detailTextLayer.backgroundColor = contentColor;
    self.imageLayer.backgroundColor = contentColor;
}

- (void)setForegroundColor:(UIColor *)foregroundColor
{
    _foregroundColor = foregroundColor;
    self.foregroundView.backgroundColor = foregroundColor;
}

- (UILabel *)textLabel
{
    return self.textLayer.textLabel;
}

- (UILabel *)detailTextLabel
{
    return self.detailTextLayer.textLabel;
}

- (UIImageView *)imageView
{
    return self.imageLayer.imageView;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [UIView animateWithDuration:0.2 animations:^{
        self.foregroundView.alpha = enabled ? 1.0 : 0.5;
    }];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
        [self fadeInAnimation];
    else
        [self fadeOutAnimation];
}

#pragma mark - Fade animation
- (void)fadeInAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.contentAnimateToColor) {
            self.textLayer.backgroundColor = self.contentAnimateToColor;
            self.detailTextLayer.backgroundColor = self.contentAnimateToColor;
            self.imageLayer.backgroundColor = self.contentAnimateToColor;
        }
        
        if (self.borderAnimateToColor && self.foregroundAnimateToColor && self.borderAnimateToColor == self.foregroundAnimateToColor) {
            self.backgroundColorCache = self.backgroundColor;
            self.foregroundView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = self.borderAnimateToColor;
            return;
        }
        
        if (self.borderAnimateToColor)
            self.layer.borderColor = self.borderAnimateToColor.CGColor;
        
        if (self.foregroundAnimateToColor)
            self.foregroundView.backgroundColor = self.foregroundAnimateToColor;
    }];
}

- (void)fadeOutAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        self.textLayer.backgroundColor = self.contentColor;
        self.detailTextLayer.backgroundColor = self.contentColor;
        self.imageLayer.backgroundColor = self.contentColor;

        if (self.borderAnimateToColor && self.foregroundAnimateToColor && self.borderAnimateToColor == self.foregroundAnimateToColor) {
            self.foregroundView.backgroundColor = self.foregroundColor;
            self.backgroundColor = self.backgroundColorCache;
            self.backgroundColorCache = nil;
            return;
        }
        
        self.foregroundView.backgroundColor = self.foregroundColor;
        self.layer.borderColor = self.borderColor.CGColor;
    }];
}

#pragma mark - Touchs
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *touchView = [super hitTest:point withEvent:event];
    if ([self pointInside:point withEvent:event])
        return self;
    
    return touchView;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.trackingInside = YES;
    self.selected = !self.selected;
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL wasTrackingInside = self.trackingInside;
    self.trackingInside = [self isTouchInside];
    
    if (wasTrackingInside && !self.isTrackingInside)
        self.selected = !self.selected;
    else if (!wasTrackingInside && self.isTrackingInside)
        self.selected = !self.selected;
    
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.trackingInside = [self isTouchInside];
    if (self.isTrackingInside && self.restoreSelectedState)
        self.selected = !self.selected;
    
    self.trackingInside = NO;
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.trackingInside = [self isTouchInside];
    if (self.isTrackingInside && self.restoreSelectedState)
        self.selected = !self.selected;
    
    self.trackingInside = NO;
    [super cancelTrackingWithEvent:event];
}

@end

///////////////////////////////////////////////
#pragma mark - PHRoundedButtonAppearanceManager

NSString *const kPHRoundedButtonCornerRadius                 = @"cornerRadius";
NSString *const kPHRoundedButtonBorderWidth                  = @"borderWidth";
NSString *const kPHRoundedButtonBorderColor                  = @"borderColor";
NSString *const kPHRoundedButtonBorderAnimateToColor         = @"borderAnimateToColor";
NSString *const kPHRoundedButtonContentColor                 = @"contentColor";
NSString *const kPHRoundedButtonContentAnimateToColor        = @"contentAnimateToColor";
NSString *const kPHRoundedButtonForegroundColor              = @"foregroundColor";
NSString *const kPHRoundedButtonForegroundAnimateToColor     = @"foregroundAnimateToColor";
NSString *const kPHRoundedButtonRestoreSelectedState         = @"restoreSelectedState";


@interface PHRoundedButtonAppearanceManager ()
@property (nonatomic, strong) NSMutableDictionary *appearanceProxys;
@end


@implementation PHRoundedButtonAppearanceManager

+ (instancetype)sharedManager
{
    static PHRoundedButtonAppearanceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PHRoundedButtonAppearanceManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
        self.appearanceProxys = @{}.mutableCopy;
    
    return self;
}

+ (void)registerAppearanceProxy:(NSDictionary *)proxy forIdentifier:(NSString *)identifier
{
    if (!proxy || ![identifier length])
        return;
    
    PHRoundedButtonAppearanceManager *manager = [PHRoundedButtonAppearanceManager sharedManager];
    [manager.appearanceProxys setObject:proxy forKey:identifier];
}

+ (void)unregisterAppearanceProxyIdentier:(NSString *)identifier
{
    if (![identifier length])
        return;
    
    PHRoundedButtonAppearanceManager *manager = [PHRoundedButtonAppearanceManager sharedManager];
    [manager.appearanceProxys removeObjectForKey:identifier];
}

+ (NSDictionary *)appearanceForIdentifier:(NSString *)identifier
{
    return [[PHRoundedButtonAppearanceManager sharedManager].appearanceProxys objectForKey:identifier];
}


@end