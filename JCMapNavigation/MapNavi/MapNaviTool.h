//
//  MapNaviTool.h
//  IOSFrame
//
//  Created by JuneCheng on 2020/10/22.
//  Copyright © 2020 zjhcsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapNaviTool : NSObject

+ (instancetype)sharedInstance;

/**
 * 开始地图导航
 *
 * @param gcjCoor 国测局经纬度坐标
 */
- (void)startMapNavi:(CLLocationCoordinate2D)gcjCoor;

@end

NS_ASSUME_NONNULL_END
