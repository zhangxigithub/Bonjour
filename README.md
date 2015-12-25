# Bonjour
communicate with other iOS devices nearby


####使用



```swift
//启动bonjour
Bonjour.sharedBonjour.bonjour() //默认用设备名 UIDevice.currentDevice().name
//或者
Bonjour.sharedBonjour.bonjour("自定义名称")
```


####发送消息

```swift
Bonjour.sharedBonjour.sendMessage("message")
}
```
####使用代理(接受消息、获取状态)

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
####使用消息(接受消息、获取状态)

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
