//
//  YBKeyboardEmojiPopView.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/13.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBKeyboardEmojModel;
@class YBKeyboardEmojiButton;

@interface YBKeyboardEmojiPopView : UIView

@property (copy, nonatomic) NSString * path;

@property (strong, nonatomic) YBKeyboardEmojModel * emoji_model;



- (void)showBtn:(YBKeyboardEmojiButton *)emoji_button;

+ (instancetype)popView;


@end
