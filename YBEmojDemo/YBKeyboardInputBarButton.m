//
//  YBKeyboardInputBarButton.m
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/23.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardInputBarButton.h"

@implementation YBKeyboardInputBarButton

- (void)setNormalStateImageString:(NSString *)normal_image_string selectedStateImage:(NSString *)selected_image_string{
    
    UIImage *norma_image = [UIImage imageNamed:normal_image_string];
    [self setImage:norma_image forState:UIControlStateNormal];
    
    UIImage *selected_image = [UIImage imageNamed:selected_image_string];
    [self setImage:selected_image forState:UIControlStateSelected];
}

@end
