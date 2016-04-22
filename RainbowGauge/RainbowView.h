//
//  RainbowView.h
//  RainbowGauge
//
//  Created by 王傲云 on 16/4/11.
//  Copyright © 2016年 王傲云. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RainbowView : UIView
/**
 *  三角形的边长
 */
@property (nonatomic, assign) IBInspectable CGFloat triangleSide;
/**
 *  彩虹半圆线宽
 */
@property (nonatomic, assign) IBInspectable CGFloat rainbowLineWidth;
/**
 *  数字Label的线宽
 */
@property (nonatomic, assign) IBInspectable CGFloat numberLabelWidth;

/**
 *  设置numberLabel的数值
 *
 *  @param number 数值
 */
- (void)setNumber:(NSInteger)number;

@end
