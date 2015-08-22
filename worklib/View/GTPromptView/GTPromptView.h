//
//  GTPromptView.h
//
//
//  Created by carusd on 12-6-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTPromptViewSetting;

/**
  提示位置
 */
typedef enum
{
	GTPromptViewLocationCenter = 1, /**< 位于屏幕中心 */
	GTPromptViewLocationLeft, /**< 位于屏幕左侧 */
	GTPromptViewLocationRight, /**< 位于屏幕右侧 */
	GTPromptViewLocationTop, /**< 位于屏幕顶部，一般在竖屏模式，且键盘出现的时候使用 */
	GTPromptViewLocationBottom /**< 位于屏幕底部 */
}GTPromptViewLocation;

/**
 提示类型
 */
typedef enum
{
    GTPromptViewTypeInfo = 1, /**< 成功 */
    GTPromptViewTypeWarning, /**< 警告 */
    GTPromptViewTypeError, /**< 错误 */
    GTPromptViewTypePlay, /**< 播放 */
    GTPromptViewTypeStop /**< 暂停 */
}GTPromptViewType;

/**
  提示视图。兼容iPad，iPhone，横竖屏，iPad版的样式参考于杂志应用，iPhone版的样式参考于资讯客户端3.0框架
 */
@interface GTPromptView : UIView
{
    GTPromptViewSetting *_setting;
}

+ (GTPromptView *)share;

/**
  根据指定位置显示提示
  @param text 提示文本
  @param location 位置
 */
+ (void)showText:(NSString *)text gravity:(GTPromptViewLocation)location;

/**
  根据指定的坐标，时间显示提示
  @param text 提示文本
  @param time 提示持续时间
  @param point 坐标
 */
+ (void)showText:(NSString *)text time:(float)time gravity:(CGPoint)point;

/**
 根据指定的时间显示提示
 @param text 提示文本
 @param time 提示持续时间
 */
+ (void)showText:(NSString *)text time:(float)time;

/**
 显示提示
 @param text 提示文本
 @param time 提示持续时间
 */
+ (void)showText:(NSString *)text;

/**
  根据指定的父视图，持续时间显示提示
  @param text 提示文本
  @param superView 提示所在的父视图
  @param time 持续时间
 */
+ (void)showText:(NSString *)text atView:(UIView *)superView time:(float)time;

/**
 根据指定的父视图显示提示
 @param text 提示文本
 @param superView 提示所在的父视图
 */
+ (void)showText:(NSString *)text atView:(UIView *)superView;

/**
 根据指定的类型显示提示。如果该提示类型对应的图片在设置 GTPromptViewSetting 中找不到，则显示默认样式的视图
 @param text 提示文本
 @param promptType 提示类型
 */
+ (void)showText:(NSString *)text
            type:(GTPromptViewType)promptType;

/**
 根据指定的类型，位置显示提示。如果该提示类型对应的图片在设置 GTPromptViewSetting 中找不到，则显示默认样式的视图
 @param text 提示文本
 @param promptType 提示类型
 */
+ (void)showText:(NSString *)text
            type:(GTPromptViewType)promptType
         gravity:(GTPromptViewLocation)location;

@end

/**
 * 提示视图设置。在AppDelegate中的方法 application:didFinishLaunchingWithOptions: 进行初始化视图样式。
 * 如果不进行初始化设置，则显示默认样式。
 * 通常是在需要显示带图标的提示视图的情况下该设置才起作用，才需要执行初始化操作。
 * 一般地，需要设置 1) 每种提示类型 GTPromptViewType 对应的图片名称，2) 提示视图大小 3) 提示视图圆角半径
 * 如果需要显示圆形的提示视图，则将视图宽高设置为相同的大小，并且圆角半径大小设置为宽(高)的1/2.
 */
@interface GTPromptViewSetting : NSObject<NSCopying>{
    
}

/**
  提示图片名称，以提示类型作为Key
 */
@property(readonly) NSDictionary *images;

/**
  提示视图初始大小
 */
@property(assign) CGSize originalSize;

/**
  提示视图初始圆角半径大小
 */
@property(assign) CGFloat originalCornerRadius;

/**
  设置提示类型对应的图片名称
  @param imageName 图片名称
 */
- (void) setImage:(NSString *)imageName forType:(GTPromptViewType) type;

/**
  获取提示设置类的单例
  @return 设置类的单例
 */
+ (GTPromptViewSetting *) getSharedSettings;


@end
