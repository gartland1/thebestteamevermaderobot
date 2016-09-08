//
//  ViewController.swift
//  Hack
//
//  Created by Alexey Demedetskii on 9/8/16.
//  Copyright © 2016 thebestteamevermade. All rights reserved.
//

import UIKit
import Moscapsule

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position :CGPoint = touch.locationInView(view)
            print(position.x)
            print(position.y)
            
        }
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
        mqttClient.publishString("{\"Left\": -4000,\"Right\": 4000}", topic: "command/wheel_speed", qos: 2, retain: true)
        
        
    }
}

