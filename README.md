DFCourier
==
DFCourier is a message sending proxy switcher. 
--
By implementing `DFCourierDelegate` protocol, there is an easy way to assign whose method signature will be used and which object the method will be forwarded to for each selector.

`DFCourier` will ask its delegate for proxy options after receiving a method call.

Multiple proxy options provided
--
DFCourier instance has two objects in its properties: the target and the proxy.

`DFCourierProxyOptionNone`: invoke the original method on target;

`DFCourierProxyOptionBefore`: sending a duplicate message to proxy between asking target's method signature and forwarding message to target. The return value from proxy will be abandon;

`DFCourierProxyOptionAfter`: sending a duplicate message to proxy after forwarding message to target. The return value from proxy will be abandon;

`DFCourierProxyOptionInstead`: taking target's method signature then forwarding message to proxy;

`DFCourierProxyOptionReserve`: taking target's method signature, if failed, asking proxy for it;

`DFCourierProxyOptionAlways`: give the invocation on proxy;

**You can use these options in combination.**

