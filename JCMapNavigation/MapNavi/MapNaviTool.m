//
//  MapNaviTool.m
//  IOSFrame
//
//  Created by JuneCheng on 2020/10/22.
//  Copyright © 2020 zjhcsoft. All rights reserved.
//

#import "MapNaviTool.h"
#import <MapKit/MapKit.h>
#import "UIWindow+CurrentViewController.h"

@interface MapNaviTool() {
    CLLocationCoordinate2D _gcjCoor;
}
@property (nonatomic, strong) NSArray<NSDictionary *> *maps;///< 地图数组
@property (nonatomic, strong) NSMutableArray<NSString *> *mapTitles;///< 地图名称数组

@end

@implementation MapNaviTool

+ (instancetype)sharedInstance
{
    static MapNaviTool *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MapNaviTool alloc] init];
        
    });
    return _sharedInstance;
}

- (void)startMapNavi:(CLLocationCoordinate2D)gcjCoor {
    _gcjCoor = gcjCoor;
    
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"请选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self.maps enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj[@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (idx == 0) {
                [self navAppleMap];
            } else {
                NSDictionary *dic = self.maps[idx];
                NSString *urlString = dic[@"url"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
                    if (!success) {
                        NSLog(@"--------openURL失败-------");
                    }
                }];
            }
        }];
        [alertSheet addAction:action];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
    [alertSheet addAction:cancelAction];
    [[UIWindow currentViewController] presentViewController:alertSheet animated:YES completion:nil];
}

#pragma mark 自定义方法

- (void)navAppleMap {
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_gcjCoor addressDictionary:nil]];
    NSArray *items = @[currentLoc, toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

/** 获取手机上安装的地图App,经纬度类型为GCJ */
- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *urlScheme = @"IOSFrame";
    
    NSMutableArray *maps = [NSMutableArray array];
    
    // 苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    // 百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    // 高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,endLocation.latitude,endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    // 谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    // 腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    return maps;
}

#pragma mark - 懒加载

- (NSMutableArray<NSString *> *)mapTitles {
    if (!_mapTitles) {
        _mapTitles = [NSMutableArray array];
        [self.maps enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_mapTitles addObject:obj[@"title"]];
        }];
    }
    return _mapTitles;
}

- (NSArray<NSDictionary *> *)maps {
    if (!_maps) {
        _maps = [self getInstalledMapAppWithEndLocation:_gcjCoor];
    }
    return _maps;
}

@end
