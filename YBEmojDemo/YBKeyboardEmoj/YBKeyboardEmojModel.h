//
//  YBKeyboardEmojModel.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/7.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YBKeyboardEmojModelType) {
    YBKeyboardEmojModelType_defaul =0,
    YBKeyboardEmojModelType_emoji// emoji 表情
};


@interface YBKeyboardEmojModel : NSObject

/** 简体中文名 */
@property (copy, nonatomic) NSString * chs;

/** 繁体中文名 */
@property (copy, nonatomic) NSString * cht;

/** gif图片文件名 */
@property (copy, nonatomic) NSString * gif_name;

/** png图片文件名 */
@property (copy, nonatomic) NSString * png_name;

/** emoji表情的编码 */
@property (copy, nonatomic) NSString * code;

/** 表情类型 */
@property (assign, nonatomic) YBKeyboardEmojModelType type;



@end
