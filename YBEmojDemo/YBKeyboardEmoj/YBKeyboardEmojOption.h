//
//  YBKeyboardEmojOption.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/7.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBKeyboardEmojOption : NSObject

/** 表情集 名称 */
@property (copy, nonatomic) NSString * emoj_option_name;

/** 表情集 描述 */
@property (copy, nonatomic) NSString * emoj_option_description;

/** 表情集 索引表情图片名 */
@property (copy, nonatomic) NSString * emoj_option_indexImageName;

/** 表情集 的序号（决定这个表情集在所有表情里面的次序） */
@property (assign, nonatomic) NSUInteger index;

/** 表情集 的本地地址*/
@property (copy, nonatomic) NSString * emoj_option_urlString;

/** 表情集 是否是编码形式 */
@property (assign, nonatomic) BOOL isCode;




@end
