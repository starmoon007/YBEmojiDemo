//
//  YBKeyBoardInputBar.h
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/23.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YBKeyboardMoreFunctionView.h"


/** 屏幕宽度 */
#define YBScreenW  [UIScreen mainScreen].bounds.size.width

/** 屏幕高度 */
#define YBScreenH  [UIScreen mainScreen].bounds.size.height

/** 通知中心 */
#define YBNotificationCenter  [NSNotificationCenter defaultCenter]

// RGB颜色
#define YBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define YBRandomColor YBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#define YBKeyBoardEmojiDragEmojiListView @"drag_emoji_list_view"


typedef NS_ENUM(NSInteger, YBKeyboardType) {
    YBKeyboard_Default = 0,
    YBKeyboard_Voice = 1,
    YBKeyboard_Emoj = 2,
    YBKeyboard_More = 3
};



@interface YBKeyBoardInputBar : UIView



@property (assign, nonatomic,readonly) BOOL activating;


@property (assign, nonatomic,readonly) YBKeyboardType keyboardType;// 暂未启用



/** 初始化方法 */
+ (instancetype)keyBoardInputBar;

/** 显示方法方法 (默认不显示在屏幕中) */
- (void)showKeyBoardInView:(UIView *)super_view;

/** 显示方法方法,是否显示在屏幕外 */
- (void)showKeyBoardInView:(UIView *)super_view inWindow:(BOOL)inWindow;







@end
