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

    @IBAction func onDrag(gr:UIPanGestureRecognizer) {
        switch gr.state {
        case .Changed:
            let point = gr.locationInView(gr.view)
            let percent = CGPoint(x: point.x/gr.view!.bounds.width, y: point.y/gr.view!.bounds.height)
            let result = CGPoint(x: percent.x * -2 + 1, y: percent.y * -2 + 1)
            print(result)
        default: return }
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

