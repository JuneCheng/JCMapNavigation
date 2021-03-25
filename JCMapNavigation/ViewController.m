//
//  ViewController.m
//  JCMapNavigation
//
//  Created by JuneCheng on 2021/3/24.
//

#import "ViewController.h"
#import "MapNaviTool.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;///<

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.button];
    
}

#pragma mark - Actions

/** 导航Action */
- (void)mapNaviAction {
    CLLocationCoordinate2D gcjCoor = CLLocationCoordinate2DMake(30.180876, 120.158472);
    [[MapNaviTool sharedInstance] startMapNavi:gcjCoor];
}

#pragma mark - 懒加载

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(100, 200, 100, 40);
        [_button setBackgroundColor:[UIColor systemBlueColor]];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:@"地图导航" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _button.layer.cornerRadius = 5.f;
        [_button addTarget:self action:@selector(mapNaviAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
