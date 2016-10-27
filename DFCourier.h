//
//  DFCourier.h
//  GetZ
//
//  Created by 方秋鸣 on 16/8/19.
//  Copyright © 2016年 makeupopular.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author fangqiuming, 16-08-19 15:08:48
 *
 *  @brief 发送选项。
 *
 *  @discussion None：使用 target 的方法签名，并发送消息给 target（默认选项）；
 *
 *  Before： 额外发送消息给 prxoy，该返回值不传递；
 *
 *  After：同上；
 *
 *  Instead：使用 proxy 的方法签名，并指定将消息发送给 proxy；
 *
 *  Reserve：如获取 target 方法签名失败，从 proxy 获取，并发送消息给 proxy；
 *
 *  Always：使用 proxy 的方法签名，不发送消息给 target。
 */
typedef NS_OPTIONS(NSUInteger, DFCourierProxyOption) {
    DFCourierProxyOptionNone = 0,
    DFCourierProxyOptionBefore = 1 << 0,
    DFCourierProxyOptionAfter = 1 << 1,
    DFCourierProxyOptionInstead = 1 << 2,
    DFCourierProxyOptionReserve = 1 << 3,
    DFCourierProxyOptionAlways = 1 << 4,
};

@protocol DFCourierProxy <NSObject>

- (DFCourierProxyOption)proxyOptionForSelector:(SEL)aSelector;

@end

/**
 *  @author fangqiuming, 16-08-19 12:08:45
 *
 *  @brief Courier 会根据 proxyOptionForSelector: 方法返回的选项，转发消息给 target 和 proxy。
 *
 *  @discussion 典型用例：将 Courier 设为代理，可以选择调用 target 还是 proxy 的代理方法。
 *
 *  包含 respondsToSelector: 方法实现，规则和发送消息一致。
 *
 *  协议中的 proxyOptionForSelector: 方法应该默认返回 DFCourierProxyOptionNone。如果没有实现某个方法，却返回其他的选项，那么请自行处理异常，Courier 不关心这些问题。
 *
 *  简单地说，Courier 实现了按规则转发消息，至于转发所引发的结果，和正常调用一样，除了：
 *
 *  DFCourierProxyOptionBefore 或 DFCourierProxyOptionAfter 所引发的调用，其返回值不会传递给调用者。
 */
@interface DFCourier : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, weak) id proxy;

@property (nonatomic) BOOL isProtocolForwarding;
@property (nonatomic) BOOL isInheritanceForwarding;
@property (nonatomic) BOOL isClassForwarding;

@end