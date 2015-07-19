//
//  YBKeyboardEmojOptionView.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/3.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBKeyboardEmojOptionView;
@class YBKeyboardEmojOption;

@protocol YBKeyboardEmojOptionViewDelegate <NSObject>

@optional
- (void)keyboardEmojOptionView:(YBKeyboardEmojOptionView *)keyboardEmojOptionView didClickOptionWithOptionModel:(YBKeyboardEmojOption *)emoji_option withIndex:(NSUInteger )index;

@end



@interface YBKeyboardEmojOptionView : UIView

@property (assign, nonatomic) id<YBKeyboardEmojOptionViewDelegate>delegate;

@property (strong, nonatomic) NSArray * option_array;

//@property (assign, nonatomic) BOOL showSendButton;

- (void)moveToOptionWithIndex:(NSUInteger )index;

@end
