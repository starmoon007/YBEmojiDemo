//
//  YBkeyboardMoreFunctionModel.h
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/29.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBkeyboardMoreFunctionModel : NSObject

/** 按钮的标题 */
@property (copy, nonatomic) NSString * title;

/** 按钮图片名(正常状态) */
@property (copy, nonatomic) NSString * icon_name_normal;

/** 按钮图片名(高亮状态) */
@property (copy, nonatomic) NSString * icon_name_selected;

/** 按钮的序号 */
@property (assign, nonatomic) NSUInteger index;


@end
