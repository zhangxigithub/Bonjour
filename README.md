# Bonjour
communicate with other iOS devices nearby

简单封装使用MultipeerConnectivity,是附近的设备可以通过wifi或者蓝牙传递消息(字符串)


![img](https://github.com/zhangxigithub/Bonjour/blob/master/demo.gif?raw=true)

[视频demo](http://v.youku.com/v_show/id_XMTQyMzc4Mzc3Mg==.html)

###首先
引入Bonjour.swift文件

###使用
```swift
//启动bonjour
Bonjour.sharedBonjour.bonjour() //默认用设备名 UIDevice.currentDevice().name
//或者
Bonjour.sharedBonjour.bonjour("自定义名称")
```


###发送消息
```swift
Bonjour.sharedBonjour.sendMessage("message")
```

###接受消息和状态有两种方法，使用其中一种即可。

#####使用代理(接受消息、获取状态)

```swift
//实现BonjourDelegate
Bonjour.sharedBonjour.delegate = self

func didReceiveMessage(message: String,peerID:MCPeerID) {
//接收到消息
}
func didConnectPeer(peerID: MCPeerID) {
//连接到
}
func didDisconnectPeer(peerID: MCPeerID) {
//失去连接
}
```
#####使用消息(接受消息、获取状态)

```swift
NSNotificationCenter.defaultCenter().addObserverForName(BonjourDidReceiveMessageNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
        //接收到消息
            let peerID  = notification.userInfo?[BonjourNotificationPeerKey]
            let message = notification.userInfo?[BonjourNotificationMessageKey]
            
        }
        
NSNotificationCenter.defaultCenter().addObserverForName(BonjourDidConnectPeerNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            //连接到
            let peerID  = notification.userInfo?[BonjourNotificationPeerKey]
            
        }
NSNotificationCenter.defaultCenter().addObserverForName(BonjourDidDisconnectPeerNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            //失去连接
            let peerID  = notification.userInfo?[BonjourNotificationPeerKey]
            
        }
        
```
