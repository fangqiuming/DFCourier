**You are reading the documentation for an older version (1.0.5) of DFCourier.**

DFCourier
==
DFCourier is a message sending proxy switcher. 
--
By implementing `DFCourierDelegate` protocol, there is an easy way to assign whose method signature will be used and which object the method will be forwarded to for each selector.

    - (DFCourierProxyOption)proxyOptionForSelector:(SEL)aSelector;

`DFCourier` will ask its delegate for proxy options after receiving a method call.

Multiple proxy options are provided.
--
    typedef NS_OPTIONS(NSUInteger, DFCourierProxyOption) {
        DFCourierProxyOptionNone = 0,
        DFCourierProxyOptionBefore = 1 << 0,
        DFCourierProxyOptionAfter = 1 << 1,
        DFCourierProxyOptionInstead = 1 << 2,
        DFCourierProxyOptionReserve = 1 << 3,
        DFCourierProxyOptionAlways = 1 << 4,
    };

You can use these options in combination.

Some details you may want to know. 
--

    @property (nonatomic, weak) id target;
    @property (nonatomic, weak) id proxy;

DFCourier instance has two objects in its properties: the target and the proxy. `DFCourierProxyOption` decides the way a method will be invoked:

- `DFCourierProxyOptionNone`: invoke the original method on target;

- `DFCourierProxyOptionBefore`: sending a duplicate message to proxy between asking target's method signature and forwarding message to the target. The return value from proxy will be abandon;

- `DFCourierProxyOptionAfter`: sending a duplicate message to proxy after forwarding a message to the target. The return value from proxy will be abandon;

- `DFCourierProxyOptionInstead`: taking target's method signature then forwarding message to proxy;

- `DFCourierProxyOptionReserve`: taking target's method signature, if failed, asking proxy for it;

- `DFCourierProxyOptionAlways`: give the invocation on proxy;

There is an example.
--
    - (GXCourierProxyOption)proxyOptionForSelector:(SEL)aSelector
    {
        if ([selectorString isEqualToString:NSStringFromSelector(@selector(tableView:didSelectRowAtIndexPath:))]) {
            return GXCourierProxyOptionAfter | GXCourierProxyOptionAlways;
        }
        return GXCourierProxyOptionNone;
    }

In this example we are watching on one of UITableViewDelegate methods, and we can create a tool to coordinate 2 table views' scrolling without resetting their delegates.

![An example](http://i.imgur.com/iFgjIA0.gif)

And more features.
--
    respondsToSelector:

This method is under the control too, and its method-forwarding will follow the same rules as the method which the selector is created from.

    conformsToProtocol:
    isKindOfClass:
    isMemberOfClass:

These three method can also be controllable if following properties are set to `true`:

    @property (nonatomic) BOOL isProtocolForwarding;
    @property (nonatomic) BOOL isInheritanceForwarding;
    @property (nonatomic) BOOL isClassForwarding;

License
--
> The MIT License (MIT)
> 
> Copyright (c) 2016 fangqiuming
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
