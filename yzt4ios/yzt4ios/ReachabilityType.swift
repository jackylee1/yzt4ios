//
//  ReachabilityType.swift
//  yzt4ios
//
//  Created by JasonFu on 15-3-13.
//  Copyright (c) 2015年 JasonFu. All rights reserved.
//

import Foundation
import SystemConfiguration

public enum Reachability {
    case WWAN,
    WiFi,
    NotConnected
}

public class ReachabilityType {
    
    public class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    
    public class func isConnectedToNetworkOfType() -> Reachability {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return .NotConnected
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let isWWAN = (flags & UInt32(kSCNetworkReachabilityFlagsIsWWAN)) != 0
        //let isWifI = (flags & UInt32(kSCNetworkReachabilityFlagsReachable)) != 0
        
        if(isReachable && isWWAN){
            return .WWAN
        }
        if(isReachable && !isWWAN){
            return .WiFi
        }
        
        return .NotConnected
        //let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        //return (isReachable && !needsConnection) ? true : false
    }
    
}