# JCMapNavigation
一行代码集成苹果地图/百度地图/高德地图/谷歌地图/腾讯地图导航功能。跳转地图App,无需集成响应地图的SDK。
<p>手机上需要安装了A地图，actionSheet列表中才会出现A地图。</p>
<p>通过url scheme携带坐标数据跳转地图App实现</p>

```
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
                    
}];
```

# 效果图
<img src="https://user-images.githubusercontent.com/36223198/112405234-dbd2fa80-8d4c-11eb-86ff-cf9e34ee57fa.png" width="250" /> <img src="https://user-images.githubusercontent.com/36223198/112405378-1dfc3c00-8d4d-11eb-98a9-c31b53441796.png" width="250" />


# 使用方法
1.先在Info.plist中注册白名单
```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>qqmap</string>
    <string>comgooglemaps</string>
    <string>iosamap</string>
    <string>baidumap</string>
</array>
```

2.项目中调用
```
// 提供GCJ国测局坐标
CLLocationCoordinate2D gcjCoor = CLLocationCoordinate2DMake(30.180876, 120.158472);
[[MapNaviTool sharedInstance] startMapNavi:gcjCoor];
```
