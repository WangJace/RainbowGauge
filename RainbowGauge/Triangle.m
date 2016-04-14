//
//  Triangle.m
//  CircleGradientLayer
//
//  Created by Jace on 5/4/16.
//  Copyright © 2016 Dinotech. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint trianglePoints[3];
    trianglePoints[0] = CGPointMake(0, 0);
    trianglePoints[1] = CGPointMake(0, CGRectGetHeight(rect));
    trianglePoints[2] = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)/2);
    CGContextAddLines(context, trianglePoints, 3);
    [[UIColor clearColor] setStroke];
    [[UIColor lightGrayColor] setFill];
    CGContextDrawPath(context, kCGPathFillStroke);

}

@end
