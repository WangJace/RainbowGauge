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

@property (weak, nonatomic) IBOutlet RainbowView *rainbowGaugeView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    _valueLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
    [_rainbowGaugeView setNumber:sender.value];
    
}
@end
