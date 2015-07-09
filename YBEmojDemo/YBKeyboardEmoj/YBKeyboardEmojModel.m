//
//  YBKeyboardEmojModel.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/7.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardEmojModel.h"
#import "MJExtension.h"

@implementation YBKeyboardEmojModel


+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"gif_name" : @"gif", @"png_name" : @"png"};
}

@end
