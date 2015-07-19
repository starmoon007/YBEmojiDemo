//
//  YBKeyboardMoreFunctionView.h
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/26.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YBkeyboardMoreFunctionModel.h"

UIKIT_EXTERN NSString * const YBKeyboardDidClickFuctionButtonNotification;
UIKIT_EXTERN NSString * const YBKeyboardDidClickEmojiNotification;
UIKIT_EXTERN NSString * const YBKeyboardDeletedEmojiNotification;
UIKIT_EXTERN NSString * const YBKeyboardShowSendButtonNotification;
UIKIT_EXTERN NSString * const YBKeyboardActivateSendButtonNotification;
UIKIT_EXTERN NSString * const YBKeyboardSendActionNotification;


@interface YBKeyboardMoreFunctionView : UIView

/** 每一页显示的按钮的排列 section: 多少行   row: 多少列(一行多少个) */
@property (strong, nonatomic) NSIndexPath * page_layoutplan; //  默认情况 section = 2; row = 4;





@end
