//
//  DFCourier.h
//  GetZ
//
//  Created by 方秋鸣 on 16/8/19.
//  Copyright © 2016年 fangqiuming.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

/**
 Proxy 应实现这一协议。
 */
@protocol DFCourierProxy <NSObject>

/**
 代理方法，详细解释参考 DFCourierProxyOption。

 @param aSelector 可以使用 NSStringFromSelector() 函数进行比较。

 @return 默认应返回 DFCourierProxyOptionNone。
 */
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

/**
 原本应接受调用的对象。
 */
@property (nonatomic, weak) id target;

/**
 方法转发的对象，同时也是 DFCourier 的代理。
 */
@property (nonatomic, weak) id proxy;

/**
 是否响应 conformsToProtocol: 方法。
 */
@property (nonatomic) BOOL isProtocolForwarding;

/**
 是否响应 isKindOfClass: 方法。
 */
@property (nonatomic) BOOL isInheritanceForwarding;

/**
 是否转发 isMemberOfClass: 方法。
 */
@property (nonatomic) BOOL isClassForwarding;

@end
