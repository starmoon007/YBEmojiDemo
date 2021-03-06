//
//  YBKeyboardEmojSet.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/7.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YBKeyboardEmojOption.h"

#import "YBKeyboardEmojModel.h"

@interface YBKeyboardEmojSet : NSObject

/** 表情集 的说明 */
@property (strong, nonatomic) YBKeyboardEmojOption * emoj_option;

/** 表情集 里面的表情数组 */
@property (strong, nonatomic) NSArray * emoj_array;

/** 该表情分多少页显示 */
@property (assign, nonatomic) NSUInteger page_count;

/** 当前是第几页 */
@property (assign, nonatomic) NSUInteger page_index;


@end
