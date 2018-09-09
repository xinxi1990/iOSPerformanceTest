//
//  DDPerformanceModel.h
//  LuoJiFM-IOS
//
//  Created by xinxi on 2018/6/15.
//  Copyright © 2018年 luojilab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/NSObject+YYModel.h>

@interface DDPerformanceModel : NSObject
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *appname;
@property (copy, nonatomic) NSString *appversion;
@property (copy, nonatomic) NSString *vcClass;
@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSString *devicesName;
@property (copy, nonatomic) NSString *idf;
@property (copy, nonatomic) NSString *memory;
@property (copy, nonatomic) NSString *battery;
@property (copy, nonatomic) NSString *cpu;
@property (copy, nonatomic) NSString *fps;
@end
