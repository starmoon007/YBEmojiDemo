//
//  YBKeyboardInputBarButton.h
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/23.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBKeyboardInputBarButton : UIButton

/** 快捷设置按钮的默认和选中图片 */
- (void)setNormalStateImageString:(NSString *)normal_image_string selectedStateImage:(NSString *)selected_image_string;



@end
