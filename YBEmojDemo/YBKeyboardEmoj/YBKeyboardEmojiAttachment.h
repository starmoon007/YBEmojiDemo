//
//  YBKeyboardEmojiAttachment.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/19.
//  Copyright (c) 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBKeyboardEmojModel;

@interface YBKeyboardEmojiAttachment : NSTextAttachment

@property (strong, nonatomic) YBKeyboardEmojModel * emoji_model;


@end
