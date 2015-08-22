//
//  GTPromptView.m
//
//
//  Created by carusd on 12-6-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "GTPromptView.h"

static GTPromptViewSetting *sharedSettings = nil;

@interface GTPromptView()

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UIButton *button;

- (void)show:(float)time;
- (void)hide;
- (void)transformWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

#pragma mark - GTPromptView

@implementation GTPromptView

@synthesize titleLabel = _titleLabel;
@synthesize button = _button;

@synthesize iconView = _iconView;

static GTPromptView *promptView = nil;
static float DefaultDuration = 1.5;

+ (void)shutdown
{
    
}

+ (GTPromptView *)share
{
    if (nil == promptView)
    {
        
        promptView  =   [[GTPromptView alloc] init];
        
    }
    return promptView;
}

+ (void)showText:(NSString *)text time:(float)time
{
    CGPoint center = [GTPromptView getPointByViewLocation:GTPromptViewLocationCenter];
    [GTPromptView showText:text time:time gravity:center];
}

+ (void)showText:(NSString *)text
{
    [GTPromptView showText:text time:DefaultDuration];
}

+ (void)showText:(NSString *)text gravity:(GTPromptViewLocation)location
{
    CGPoint point = [GTPromptView getPointByViewLocation:location];
    
    [GTPromptView showText:text time:DefaultDuration gravity:point];
}

+ (void)showText:(NSString *)text time:(float)time gravity:(CGPoint)point
{
    UIView *superView = [GTPromptView getDefaultParentView];
    
    [GTPromptView showText:text icon:nil gravity:point atView:superView time:time];
}

+ (void)showText:(NSString *)text atView:(UIView *)superView time:(float)time
{
    CGPoint point = [GTPromptView getPointByViewLocation:GTPromptViewLocationCenter];
    
    [GTPromptView showText:text icon:nil gravity:point atView:superView time:time];
    
}

+ (void)showText:(NSString *)text atView:(UIView *)superView
{
    [GTPromptView showText:text atView:superView time:DefaultDuration];
}

+ (void)showText:(NSString *)text
            type:(GTPromptViewType)promptType
{

    GTPromptViewLocation location = GTPromptViewLocationCenter;
    
    [GTPromptView showText:text type:promptType gravity:location];
}

+ (void)showText:(NSString *)text
            type:(GTPromptViewType)promptType
         gravity:(GTPromptViewLocation)location
{
    float duration = DefaultDuration;
    
    NSString *imageKey = [NSString stringWithFormat:@"%i",promptType];
    NSString *imageName = [[[GTPromptViewSetting getSharedSettings] images] objectForKey:imageKey];
        
    CGPoint point = [GTPromptView getPointByViewLocation:location];
    
    UIView *superView = [GTPromptView getDefaultParentView];
    
    [GTPromptView showText:text icon:imageName gravity:point atView:superView time:duration];
}

+ (void)showText:(NSString *)text
            icon:(NSString *)imageName
         gravity:(CGPoint)point
          atView:(UIView *)superView
            time:(float)time
{
    
    GTPromptView *promptView      =   [GTPromptView share];
    
    GTPromptViewSetting *setting = [GTPromptViewSetting getSharedSettings];
    
    //阻止上一次的消失动画
    [NSObject cancelPreviousPerformRequestsWithTarget:promptView selector:@selector(hide) object:nil];
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    //以rootViewController方向来画出视图
    [promptView transformWithInterfaceOrientation:statusBarOrientation];
    
    if (nil != [promptView superview]) {
        [promptView removeFromSuperview];
    }
    
    [superView addSubview:promptView];
    [superView bringSubviewToFront:promptView];
    
    promptView.titleLabel.text = text;
    
    UIImage *iconImage = [UIImage imageNamed:imageName];
    promptView.iconView.image = iconImage;
    
    if (iconImage != nil) {
        
        //大小
        CGSize originalSize = [setting originalSize];
        promptView.bounds = CGRectMake(0, 0, originalSize.width, originalSize.height);
        
        //圆角半径
        promptView.layer.cornerRadius = [setting originalCornerRadius];
        
        float width = UIInterfaceOrientationIsLandscape(statusBarOrientation) ? promptView.frame.size.height : promptView.frame.size.width;
        
        //图标
        promptView.iconView.frame = CGRectMake(( width - iconImage.size.width ) * 0.5 , 20, iconImage.size.width, iconImage.size.height);
        
        //标题
        CGFloat padding = 10;
        CGFloat titleWidth = width - padding * 2;
        CGSize size = [text sizeWithFont:promptView.titleLabel.font];
        
        if (size.width  > titleWidth) {
            promptView.titleLabel.numberOfLines = 1;
            promptView.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
        else {
            promptView.titleLabel.numberOfLines = 3;
            promptView.titleLabel.adjustsFontSizeToFitWidth = NO;
        }
        
        promptView.titleLabel.frame = CGRectMake( padding, CGRectGetMaxY(promptView.iconView.frame), titleWidth, size.height + 15);
        
    }
    else {
        
        promptView.layer.cornerRadius = 5;
        
        //根据文字来定视图大小
        CGSize size = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [promptView.titleLabel.text sizeWithFont:promptView.titleLabel.font] : [text sizeWithFont:promptView.titleLabel.font constrainedToSize:CGSizeMake(280, 60)];
        
        float screenWidth = UIInterfaceOrientationIsLandscape(statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
        CGRect tFrame = CGRectMake(0, 0, MIN(screenWidth * 0.75, size.width), size.height);
        
        CGRect frame = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectInset(tFrame, -30,  -50) : CGRectInset(tFrame, -10,  -10);
        
        promptView.frame = frame;
        
        [promptView.titleLabel setFrame: UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGRectInset(promptView.bounds, 0,  50) : promptView.bounds];

        [promptView.button setFrame:promptView.bounds];

    }
    
    promptView.center = point;
    
    //显示
    [promptView show:time];
}

#pragma mark - private
+(CGPoint)getPointByViewLocation:(GTPromptViewLocation )location
{
    id delegate = [[UIApplication sharedApplication] delegate];
    CGPoint point = CGPointMake([delegate window ].frame.size.width/2,
                                [delegate window ].frame.size.height/2);
    
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
	switch (orientation) {
		case UIDeviceOrientationPortrait:
		{
            if (location == GTPromptViewLocationTop) {
                point.y = point.y / 2.0;
            }
            else if (location == GTPromptViewLocationBottom) {
                point.y = point.y / 2.0 * 3;
            }
            else if (location == GTPromptViewLocationLeft) {
                point.x = point.x / 2.0;
            }
            else if (location == GTPromptViewLocationRight) {
                point.x = point.x / 2.0 * 3;
            }
			break;
		}
		case UIDeviceOrientationPortraitUpsideDown:
		{
            if (location == GTPromptViewLocationTop) {
                point.y = point.y / 2.0 * 3;
            }
            else if (location == GTPromptViewLocationBottom) {
                point.y = point.y / 2.0;
            }
            else if (location == GTPromptViewLocationLeft) {
                point.x = point.x / 2.0 * 3;
            }
            else if (location == GTPromptViewLocationRight) {
                point.x = point.x / 2.0;
            }
			break;
		}
		case UIDeviceOrientationLandscapeLeft:
		{
            if (location == GTPromptViewLocationTop) {
                point.x = point.x / 2.0 * 3;
            }
            else if (location == GTPromptViewLocationBottom) {
                point.x = point.x / 2.0;
            }
            else if (location == GTPromptViewLocationLeft) {
                point.y = point.y / 2.0;
            }
            else if (location == GTPromptViewLocationRight) {
                point.y = point.y / 2.0 * 3;
            }
            
			break;
		}
		case UIDeviceOrientationLandscapeRight:
		{
            if (location == GTPromptViewLocationTop) {
                point.x = point.x / 2.0 ;
            }
            else if (location == GTPromptViewLocationBottom) {
                point.x = point.x / 2.0 * 3;
            }
            else if (location == GTPromptViewLocationLeft) {
                point.y = point.y / 2.0 * 3;
            }
            else if (location == GTPromptViewLocationRight) {
                point.y = point.y / 2.0;
            }
            
			break;
		}
		default:
			break;
	}

    return point;
}

+ (UIView *)getDefaultParentView
{
    id delegate = [[UIApplication sharedApplication] delegate];
    return [delegate window];
}

#pragma mark - init and dealloc
- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.layer.cornerRadius     =   5;
        self.backgroundColor        =   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        
        UILabel *label  =   [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel      =   label;
        
        [self addSubview:_titleLabel];
        _titleLabel.textAlignment    =   NSTextAlignmentCenter;
        _titleLabel.textColor        =   [UIColor whiteColor];
        _titleLabel.backgroundColor  =   [UIColor clearColor];
        _titleLabel.lineBreakMode    =   NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines    =   3;
        
        CGFloat fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 25 : 16;
        _titleLabel.font = [UIFont systemFontOfSize:fontSize];
        
        self.alpha = 0;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchDown];
        self.button = button;     
        [self addSubview:_button];
        
    }
    return self;
}


- (void)show:(float)time
{
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha          =   1;
    } completion:^(BOOL finished) {
        //添加监视旋转的通知
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter]; 
        [center removeObserver:self];
        [center addObserver:self 
                   selector:@selector(doRotate:)
                       name:UIDeviceOrientationDidChangeNotification
                     object:nil];
        
        //隐藏
        [self performSelector:@selector(hide) withObject:nil afterDelay:time];
    }];
    
    
}

- (void)hide
{
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha          =   0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

- (BOOL)isKeyboardVisible
{
    UIWindow *window    =   [UIApplication sharedApplication].keyWindow;
    return window.keyWindow;
}

- (void)transformWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
    
    switch (interfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0, 0.0f, 0.0f, 1.0f);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI, 0.0f, 0.0f, 1.0f);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI*1.5, 0.0f, 0.0f, 1.0f);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/2, 0.0f, 0.0f, 1.0f);
            break;
        default:
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/2, 0.0f, 0.0f, 1.0f);
            break;
    }
    self.layer.transform = rotationAndPerspectiveTransform;
}

- (void)doRotate:(NSNotification *)notification
{
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;

    [UIView animateWithDuration:duration
                     animations:^{
                         [self transformWithInterfaceOrientation:statusBarOrientation];
                     }];
    
}

@end

#pragma mark - GTPromptViewSetting

@implementation GTPromptViewSetting


- (void) setImage:(NSString *)imageName forType:(GTPromptViewType) type
{
	if (!_images) {
		_images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (imageName)
    {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[_images setValue:imageName forKey:key];
	}
}

- (id) copyWithZone:(NSZone *)zone{
    
	GTPromptViewSetting *copy = [GTPromptViewSetting new];

    copy.originalCornerRadius = self.originalCornerRadius;
    copy.originalSize = self.originalSize;
    
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[_images valueForKey:key] forType:[key intValue]];
	}
	
	return copy;
}

#pragma mark - static 

+ (GTPromptViewSetting *) getSharedSettings{
    
	if (!sharedSettings) {

		sharedSettings = [GTPromptViewSetting new];
        
	}
	
	return sharedSettings;
	
}

@end
