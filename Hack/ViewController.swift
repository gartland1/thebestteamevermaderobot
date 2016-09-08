//
//  ViewController.swift
//  Hack
//
//  Created by Alexey Demedetskii on 9/8/16.
//  Copyright © 2016 thebestteamevermade. All rights reserved.
//

import UIKit
import Moscapsule



public class ViewController: UIViewController {

    private var imageFeed : UIImageView? = nil
    private var queue = NSOperationQueue()
    
    override public func viewDidLoad() {
        
        //add image feed view to main uiview
        self.imageFeed = UIImageView(frame: self.view.frame)
        self.view.insertSubview(imageFeed!, atIndex: 0)
        
        super.viewDidLoad()
    }

    
    @IBAction func btnFeed(sender: AnyObject) {
        if(queue.operationCount <= 0 ){
            let op = FeedQueueOperation()
            op.subCallback(for: {image in
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageFeed?.image = image
                })
            })
            queue.addOperation(op)
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dance() {
        let mqttConfig = MQTTConfig(clientId: "test", host: "192.168.1.107", port: 1883, keepAlive: 60)
        mqttConfig.onPublishCallback = { messageId in
            NSLog("published (mid=\(messageId))")
        }
        mqttConfig.onMessageCallback = { mqttMessage in
            NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
        }
        mqttConfig.onConnectCallback = { x in
            print("Connected!!! \(x)")
        }
        
        // create new MQTT Connection
        let mqttClient = MQTT.newConnection(mqttConfig)
        
        // publish and subscribe
        mqttClient.publishString("{\"Left\": 0,\"Right\": 0}", topic: "command/wheel_speed", qos: 2, retain: true)
        
        
    }
}

