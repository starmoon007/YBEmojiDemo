//
//  YBKeyboardEmojSet.m
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/7.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardEmojSet.h"
#import "MJExtension.h"


@implementation YBKeyboardEmojSet

-(void)setEmoj_option:(YBKeyboardEmojOption *)emoj_option{
    _emoj_option = emoj_option;
    
    NSString *path_string = [NSString stringWithFormat:@"%@info.plist",_emoj_option.emoj_option_urlString];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:path_string ofType:nil];
    self.emoj_array = [YBKeyboardEmojModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];

}



@end
