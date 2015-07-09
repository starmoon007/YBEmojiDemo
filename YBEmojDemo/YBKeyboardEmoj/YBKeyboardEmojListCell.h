//
//  YBKeyboardEmojListCell.h
//  YBEmojDemo
//
//  Created by Starmoon on 15/7/7.
//  Copyright © 2015年 macbook air. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBKeyboardEmojSet;

@interface YBKeyboardEmojListCell : UICollectionViewCell

@property (assign, nonatomic) BOOL backward;

@property (strong, nonatomic) YBKeyboardEmojSet * emoj_set;


@end
