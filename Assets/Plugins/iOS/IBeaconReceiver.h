//
//  IBeaconReceiver.m
//
//  Created by Brad Jiao on 13.06.14.
//  Copyright (c) 2014 Brad Jiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

extern void UnitySendMessage(const char *, const char *, const char *);

@interface IBeaconReceiver : NSObject 
@end
