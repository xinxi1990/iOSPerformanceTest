# iOS性能采集

1.在源码中增加performancefiles文件</br>
2.可采集内存、cpu、fps等性能指标</br>
3.在AAPLAppDelegate.m中didFinishLaunchingWithOptions方法中初始化性能采集</br>
4.输出log日志如下
```
{
    "cpu": "0.4",
    "fps": "60 FPS",
    "version": "11.2",
    "appname": "xxxxxx",
    "battery": "-100.0",
    "appversion": "5.0.4",
    "time": "2018-09-07 11:45:24",
    "memory": "141.9",
    "devicesName": "xxxxxx",
    "vcClass": "xxxxxx",
    "idf": "8863F83E-70CB-43D5-B6C7-EAB85F3A2AAD"
}
```

# 项目管理
使用xcode cocoapods管理,podfile中使用yykit