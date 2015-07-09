//
//  YBKeyboardEmojListView.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/7.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBKeyboardEmojSet;


@interface YBKeyboardEmojListView : UIView

@property (strong, nonatomic) YBKeyboardEmojSet * emoji_set;

@property (assign, nonatomic) BOOL backward;

@end
