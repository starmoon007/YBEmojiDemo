//
//  YBKeyboardEmojOptionCell.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/6.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBKeyboardEmojOption;


@interface YBKeyboardEmojOptionCell : UICollectionViewCell

/** 表情集 */
@property (strong, nonatomic) YBKeyboardEmojOption * emoj_option;

@end
