//
//  SocketIOManager.swift
//  SparkPerso
//
//  Created by  on 30/10/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager {
    //WEB SOCKET CONTEXTE
    struct Context {
        var secure:Bool
        var ip:String
        var port:String
        var modeVerbose:Bool
        
        func fullIp() -> String {
            return "http\((secure) ? "s" : "")://\(ip):\(port)"
        }
        
        static func debugContext() -> Context {
            return Context(secure: false, ip: "169.254.27.200", port: "3000", modeVerbose: false);
        }
    }
    
    static let instance = SocketIOManager()
          
    var manager:SocketManager?
    var socket:SocketIOClient?
    
    init() {}
    
    func setup(context: Context = Context.debugContext()) {
        manager = SocketManager(socketURL: URL(string: context.fullIp())!, config: [.log(context.modeVerbose), .compress])
        socket = manager?.defaultSocket
    }
    
    func connect(callback:@escaping (()->()))  {
        listenToConnection(callback: callback)
        socket?.connect()
    }
    
    func listenToConnection(callback:@escaping (()->())) {
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            callback()
        }
    }
    
    func on(channel:String, callback:@escaping (([Any])->())) {
        socket?.on(channel) {data, ack in
            callback(data)
        }
    }
    
    func on(channel:String, callback:@escaping ((String?)->())) {
        socket?.on(channel) {data, ack in
            if let d = data.first,
                let dataStr = d as? String {
                callback(dataStr)
            }
            else {
                callback(nil)
            }
        }
    }
    
    func emit(channel:String, value:String, callback:@escaping (()->())) {
        socket?.emit(channel, value)
    }
    
    func emit(channel:String, value:SocketData) {
        socket?.emit(channel, value)
    }
    
    func emit(channel:String, values:SocketData...) {
        socket?.emit(channel, with: values)
    }
/*

    socket.on("currentAmount") {data, ack in
        guard let cur = data[0] as? Double else { return }
        
        socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
            socket.emit("update", ["amount": cur + 2.50])
        }

        ack.with("Got your currentAmount", "dude")
    }

    socket.connect()
     */
}
