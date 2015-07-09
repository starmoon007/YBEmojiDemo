//
//  YBKeyboardVoiceBillboard.m
//  YBEmojDemo
//
//  Created by 杨彬 on 15/6/29.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import "YBKeyboardVoiceBillboard.h"
#import "UIView+Extension.h"

@interface YBKeyboardVoiceBillboard ()

@property (weak, nonatomic) IBOutlet UIView * origin;

@property (weak, nonatomic) IBOutlet UIView *item_bg_view;

@property (weak, nonatomic) IBOutlet UILabel *talkback_label;

@property (weak, nonatomic) IBOutlet UILabel *record_label;

/** 能够移动的距离 */
@property (assign, nonatomic) CGFloat canMovie_distance;

/** item_bg_view 原始的X值 */
@property (assign, nonatomic) CGFloat item_bg_view_OriginalX;


@end

@implementation YBKeyboardVoiceBillboard


- (void)moveWithScale:(CGFloat )scale{
    self.item_bg_view.x = self.item_bg_view_OriginalX - scale * self.canMovie_distance;
    
    if (self.item_bg_view.x < (self.width - self.item_bg_view.width) /2.0){
        self.record_label.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.93 alpha:1];
        self.talkback_label.textColor = [UIColor lightGrayColor];
    }else{
        self.record_label.textColor = [UIColor lightGrayColor];
        self.talkback_label.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.93 alpha:1];
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.origin.layer.cornerRadius = self.origin.width /2.0;
    self.origin.layer.masksToBounds = YES;
    
    CGFloat talkback_label_width = self.talkback_label.width;
    CGFloat record_label_width = self.record_label.width;
    CGFloat item_bg_view_width = self.item_bg_view.width;
    
    self.item_bg_view.x = self.item_bg_view.x + item_bg_view_width/2.0 - talkback_label_width/2.0;
    
    self.item_bg_view_OriginalX = self.item_bg_view.x;
    
    self.canMovie_distance = item_bg_view_width - (talkback_label_width + record_label_width )/2.0;
    
}



#pragma mark - Set and Get

+ (instancetype)voiceBillboard{
    return [[[NSBundle mainBundle]loadNibNamed:@"YBKeyboardVoiceBillboard" owner:self options:nil] lastObject];
}


@end
