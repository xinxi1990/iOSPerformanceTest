//
//  getperformance.m
//  LuoJiFM-IOS
//
//  Created by xinxi on 2018/6/14.
//  Copyright © 2018年 luojilab. All rights reserved.
//


#import <mach/mach.h>
#import <AdSupport/ASIdentifierManager.h>

#import "getperformance.h"
#import "DDPerformanceModel.h"


@interface getperformance ()
@property (nonatomic, weak) UIViewController *vc;



@property (nonatomic, assign) NSString *percount;


@end

@implementation getperformance{
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    NSString *currentfps;
    
}


/*
*获取当前时间
*/
- (NSString *)get_time{
   // double time= [[NSDate date] timeIntervalSince1970];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss SS "];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
//    NSString *timetostring;
//    timetostring = [NSString stringWithFormat:@"%.1lf",time];
    return dateString;
    
}



/*
 *获取设备名称
 */
- (NSString *) get_devicesName {
    NSString *devicesName = [UIDevice currentDevice].name; //设备名称
    NSLog(@"performance   devicesName:%@", devicesName);
    return devicesName;
    
}

/*
 *获取系统版本
 */
- (NSString *) get_systemVersion{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion; //系统版本
    NSLog(@"performance   version:%@", systemVersion);
    return systemVersion;
}

/*
 *获取设备idf
 */
- (NSString *) get_idf {
    NSString *idf = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSLog(@"performance   idf:%@", idf);
    return idf;

}


/*
 *获取app名称
 */
- (NSString *) get_appname{
//    NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    NSLog(@"performance   appname:%@", appname);
    return @"UICatalog";

}


/*
*获取app版本号
*/
- (NSString *) get_appversion{
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"performance   appversion:%@", appVerion);
    return appVerion;

}


/*
 *获取电池信息
 */

- (NSString *) get_battery {
    [UIDevice currentDevice].batteryMonitoringEnabled =YES;
    //NSLog(@"performance   battery:%.2f", [UIDevice currentDevice].batteryLevel);

    NSString *batterytostring ;
    batterytostring = [NSString stringWithFormat:@"%0.1lf",[UIDevice currentDevice].batteryLevel * 100];
    return batterytostring;
}


/**
 * 获取cpu
 */
- (NSString *) get_cpu{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;

    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return [ NSString stringWithFormat: @"%f" ,-1];
    }

    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;

    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;

    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads

    basic_info = (task_basic_info_t)tinfo;

    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return [ NSString stringWithFormat: @"%f" ,-1];
    }
    if (thread_count > 0)
        stat_thread += thread_count;

    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;

    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            tot_cpu = -1;
            //return -1;
        }

        basic_info_th = (thread_basic_info_t)thinfo;

        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }

    } // for each thread

    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);

    NSString *tostring = nil ;
    tostring = [ NSString stringWithFormat: @"%.1f" ,tot_cpu];
    NSLog (@"performance  cpu:%@",tostring);

    return tostring;
}



/**
 *  获取内存
 */
- (NSString *)get_memory {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }

    double mem = memoryUsageInByte / (1024.0 * 1024.0);
    NSString *memtostring ;
    memtostring = [NSString stringWithFormat:@"%.1lf",mem];

    return memtostring;
}






/**
 *获取当前vc
 */
- (UIViewController *) get_vc {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)keyWindow.rootViewController;
            UINavigationController *nav = tab.childViewControllers[tab.selectedIndex];
            UIViewController *content = [nav topViewController];
            //目前这款获取vc问题
            //weakSelf.vc = [content contentViewController];
        }
    });

    //printf("vc   %s\n", [NSStringFromClass(self.vc.class) UTF8String]);
    //NSLog (@"vc   %@", self.vc);
    return self.vc;
}



/*
*获取当前fps
*/
- (void)get_fps{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];

        // NOTE: 子线程的runloop默认不创建； 在子线程获取 currentRunLoop 对象的时候，就会自动创建RunLoop
        // 这里不加到 main loop，必须创建一个 runloop

        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [_link addToRunLoop:runloop forMode:NSRunLoopCommonModes];

        // 必须 timer addToRunLoop 后，再run
        [runloop run];
    });
}



- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }

    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;

    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    currentfps=text;

    self.percount = text;
    NSLog(@"fps%@:", text);


}



/*
 * 性能采集子线程
 */

- (void) performancethread {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"performance   ======get performance======");

        [self get_fps];

        while (true) {

            DDPerformanceModel * model = [DDPerformanceModel new];

            model.time=[self get_time];
            model.appname=[self get_appname];
            model.appversion=[self get_appversion];
            model.idf =[self get_idf];
            model.devicesName =[self get_devicesName];
            model.version = [self get_systemVersion ];
            model.vcClass = NSStringFromClass([self get_vc].class);
            model.memory = [self get_memory];
            model.battery = [self get_battery];
            model.cpu = [self get_cpu];
            model.fps = self.percount;
            
            NSString *json = [model modelToJSONString];
            
//            printf(" getperformance    %s\r\n", [json UTF8String]);
            NSLog(@"getperformance model  %@", json);
            
            sleep(5);
        }
    }];
    [thread start];
    

    NSLog(@"performance   ======continue mainblock======");
    
}

@end


 



