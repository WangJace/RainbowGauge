//
//  ViewController.m
//  RainbowGauge
//
//  Created by 王傲云 on 16/4/11.
//  Copyright © 2016年 王傲云. All rights reserved.
//

#import "ViewController.h"
#import "RainbowView.h"
#import "Triangle.h"

@interface ViewController ()
{
    Triangle *_triangle;
    UILabel *_numberLabel;
}

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    RainbowView *rainbowView = [[RainbowView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    [self.view addSubview:rainbowView];
    
    [self triangle];
    [self numberLabel];
}

- (void)triangle
{
    _triangle = [[Triangle alloc] initWithFrame:CGRectMake(42, 140, 10, 10)];
    _triangle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_triangle];
}

- (void)numberLabel
{
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 133, 23, 23)];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [ UIFont systemFontOfSize:13];
    _numberLabel.text = @"0";
    [self.view addSubview:_numberLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    _valueLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    _numberLabel.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    
    CGFloat angle = 180*(sender.value/100.0)*M_PI/180.0;
    CGFloat radius = (200-PROGRESS_LINE_WIDTH*2)/2+10;
    
    [UIView animateWithDuration:0.01 animations:^{
        CATransform3D transform = CATransform3DIdentity;
        if (sender.value <= 50) {
            transform = CATransform3DTranslate(transform, radius-radius*cos(angle), -radius*sin(angle), 0);
        }
        else {
            transform = CATransform3DTranslate(transform, radius+radius*sin(angle-M_PI/2.0), -radius*cos(angle-M_PI/2.0), 0);
        }
        transform = CATransform3DRotate(transform, angle, 0, 0, 1);
        _triangle.layer.transform = transform;
        
        CGFloat radius2 = radius + 20;
        CATransform3D numberTransform = CATransform3DIdentity;
        if (sender.value <= 50) {
            _numberLabel.textAlignment = NSTextAlignmentRight;
            numberTransform  = CATransform3DTranslate(numberTransform, radius2-radius2*cos(angle), -radius2*sin(angle), 0);
        }
        else {
            _numberLabel.textAlignment = NSTextAlignmentLeft;
            numberTransform = CATransform3DTranslate(numberTransform, radius2+radius2*sin(angle-M_PI/2.0), -radius2*cos(angle-M_PI/2.0), 0);
        }
//        numberTransform = CATransform3DRotate(numberTransform, angle, 0, 0, 1);
        _numberLabel.layer.transform = numberTransform;
    }];
}
@end
