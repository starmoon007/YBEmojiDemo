//
//  YBkeyboardMoreFunctionButton.m
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/29.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBkeyboardMoreFunctionButton.h"
#import "YBkeyboardMoreFunctionModel.h"
#import "UIView+Extension.h"

@implementation YBkeyboardMoreFunctionButton



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    
    CGFloat imageView_wh = self.imageView.height;
    
    
    CGFloat titleLabel_wh = self.titleLabel.height;
    self.titleLabel.width = self.width;
    
    self.imageView.x = (self.width - self.imageView.width) /2;
    self.imageView.y = (self.height - imageView_wh - titleLabel_wh - 5)/2;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.height - titleLabel_wh - self.imageView.y;
}


-(void)setFunction_model:(YBkeyboardMoreFunctionModel *)function_model{
    _function_model = function_model;
    
    [self setTitle:_function_model.title forState:UIControlStateNormal];
    
    
    [self setImage:[UIImage imageNamed:_function_model.icon_name_normal] forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:_function_model.icon_name_selected] forState:UIControlStateHighlighted];
    
}


+ (instancetype)functionButton{
    return [[[self class] alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.clipsToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return self;
}


@end
