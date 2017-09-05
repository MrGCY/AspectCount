//
//  CYAspectTrackManager.m
//  AspectsCount
//
//  Created by Mr.GCY on 2017/9/5.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "CYAspectTrackManager.h"
#import "Aspects.h"
#import <UIKit/UIKit.h>

//所有统计事件
#define UserTrackedEvents @"UserTrackedEvents"
//统计事件名称
#define UserEventName @"UserEventName"
//统计事件方法名
#define UserEventSelectorName @"UserEventSelectorName"
//事件block
#define UserEventHandlerBlock @"UserEventHandlerBlock"
//打点的ID
#define UserEventID @"UserEventID"
@interface CYAspectTrackManager()


@end
@implementation CYAspectTrackManager
+(void)setupAllTracksAspect{
    //初始化所有的统计
    [CYAspectTrackManager trackEventVC];
    [CYAspectTrackManager trackAllTapAndButtonEvent];
}
//控制器生命周期的统计
+(void)trackEventVC{
    //页面出现前
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
        //统计代码
        Class cls = [info.instance class];
        NSString * clsStr = NSStringFromClass(cls);
        NSLog(@"%@------即将出现",clsStr);
    } error:nil];
    //页面消失前
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
        //统计代码
        Class cls = [info.instance class];
        NSString * clsStr = NSStringFromClass(cls);
        NSLog(@"%@------即将消失",clsStr);
    } error:nil];
}
+(void)trackAllTapAndButtonEvent{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //读取配置文件 获取所有需要统计的事件列表
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"count" ofType:@"plist"];
        NSDictionary * allEventsDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if (allEventsDict) {
            //遍历所有要添加统计的类
            for (NSString * classNameStr in allEventsDict.allKeys) {
                //获取当前类对象
                Class className = NSClassFromString(classNameStr);
                //获取点击事件
                NSDictionary * subEventsDic = [allEventsDict objectForKey:classNameStr];
                NSArray * subEventsArray = [subEventsDic objectForKey:UserEventName];
                for (NSDictionary * subEvent in subEventsArray) {
                    //遍历需要添加的每一个事件
                    //事件ID
                    NSString * eventID = [subEvent objectForKey:UserEventID];
                    NSString * selectorName = [subEvent objectForKey:UserEventSelectorName];
                    SEL sel = NSSelectorFromString(selectorName);
                    [CYAspectTrackManager addTrackAspectEvent:className selector:sel eventID:eventID];
                }
            }
        }
    });
}
+(void)addTrackAspectEvent:(Class)cls selector:(SEL)selector eventID:(NSString *)eventId{
    [cls aspect_hookSelector:selector withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info ,id object){
        //添加统计代码
        Class cls = [info.instance class];
        NSString * clsStr = NSStringFromClass(cls);
        NSLog(@"%@-----%@-------%@",clsStr,object,eventId);
    }error:nil];
}
@end
