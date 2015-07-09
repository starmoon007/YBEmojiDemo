//
//  YBKeyboardEmojiButton.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/8.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBKeyboardEmojModel;

@interface YBKeyboardEmojiButton : UIButton

@property (copy, nonatomic) NSString * path;

@property (strong, nonatomic) YBKeyboardEmojModel * emoji_model;

@end
