//
//  ViewController.swift
//  demo
//
//  Created by zhangxi on 12/25/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController,UITextFieldDelegate,BonjourDelegate {
    func didLost(peerID: MCPeerID) {
        
    }
    
    func didConnectPeer(peerID: MCPeerID) {
        
    }
    
    func didDisconnectPeer(peerID: MCPeerID) {
        
    }
    
    func didReceiveMessage(message: String, peerID: MCPeerID) {
        
        let array = message.components(separatedBy: ",")
        if array.count == 2
        {
            let positon = CGPoint(x: CGFloat(Float(array[0]) ?? 0), y: CGFloat(Float(array[1]) ?? 0))
            self.showCircle(position: positon)
        }
    }
    

    let bonjour = Bonjour()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bonjour.delegate = self
        bonjour.bonjour()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let position = touches.first?.location(in: self.view)
        {
            self.showCircle(position: position)
            bonjour.sendMessage(message: String(format: "%f,%f", position.x,position.y))
        }
    }

    
    
    func showCircle(position:CGPoint)
    {
        let circle    = UIImageView(image: UIImage(named: "circle"))
        circle.frame  = CGRect(x: 0, y: 0, width: 20, height: 20)
        circle.center = position
        
        self.view.addSubview(circle)
        UIView.animate(withDuration: 1, animations: {
            let center = circle.center
            circle.frame.size.width  = 100
            circle.frame.size.height = 100
            circle.center = center
            circle.alpha  = 0
        }) { (finish) in
            circle.removeFromSuperview()
        }
    }
    
}

