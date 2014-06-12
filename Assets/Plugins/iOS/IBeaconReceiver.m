//
//  IBeaconReceiver.m
//  ble_plugin
//
//  Created by Brad Jiao on 13.06.14.
//  Copyright (c) 2014 Brad Jiao. All rights reserved.
//

#import "IBeaconReceiver.h"


@interface IBeaconReceiver() <CBCentralManagerDelegate,CLLocationManagerDelegate>

@property (strong,nonatomic) NSMutableArray *regions;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation IBeaconReceiver

#pragma check requires

- (BOOL) checkDeviceAvilable
{
    NSLog(@"Check Bluetooth  ...");
    
    /*CBCentralManager *cbCentralMgr = */[[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    NSLog(@"Checking Location Service ...");
    if (![CLLocationManager locationServicesEnabled]) {
        [self showMessages:@" Location services are not enabled."];
    }
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        [self showMessages:@"Location services not authorised."];
    }
    
    NSLog(@"Checking Ranging require ...");
    
    if (![CLLocationManager isRangingAvailable]) {
        [self showMessages:@" Ranging is not available."];
        return NO;
    }
    
    NSLog(@"Checking Monitor require ...");
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        [self showMessages:@" Region monitoring is not available for CLBeaconRegion class."];
        return NO;
    }
    return YES;
}


//for check bluetooth state //CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    bool is_errstate = false;
    NSString* err_message = @"";
    switch (central.state) {
            
        case CBCentralManagerStatePoweredOn:
            break;
        case CBCentralManagerStateUnsupported:
            is_errstate = YES;
            err_message = @"The platform does not support Bluetooth low energy.";
            break;
        default:
            is_errstate = YES;
            err_message = [NSString stringWithFormat: @"Bluetooth not available:%d, please open and authorize to use.",central.state];
            break;
    }
    if (is_errstate) {
        [self showMessages:err_message];
    }
}

- (void) showMessages:(NSString*)message
{
    [self showMessages:message
             withTitle:@"Message"
         isCriticalErr:NO];
}
- (void) showMessages:(NSString*)message
            withTitle:(NSString*) title
        isCriticalErr:(bool) isCriticalErr
{
    NSLog(@"%@",message);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messages"
                                                    message:message
                                                   delegate: self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK",nil];
    
    [alert show];
    [alert release];
    
}


#pragma inits and apis for use

static IBeaconReceiver * sharedBeaconReceiver;
+ (IBeaconReceiver *)getSharedBeaconReceiver{
    
    if (sharedBeaconReceiver == nil) {
        sharedBeaconReceiver = [[IBeaconReceiver alloc]init];
    }
    return sharedBeaconReceiver;
}

- (id) init{
    self = [super init];
    
    if (self) {
        
        [self checkDeviceAvilable];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return self;
}

- (void) startReceiveBeaconWithUUID:(NSUUID*)uuid
          shouldSimulateRegionEnter:(bool) simulate{
    
    CLBeaconRegion *tempRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                    identifier:[uuid UUIDString]];
    if (self.regions == nil){
        self.regions = [[NSMutableArray alloc] initWithObjects:tempRegion, nil];
    }
    else{
        [self.regions addObject:tempRegion];
    }
    
    [self.locationManager startMonitoringForRegion:tempRegion];
    
    NSLog(@"Receiving for region: %@.", tempRegion);
    
    if (simulate) {
        NSLog(@"simulate region entered, and Ranging Beacon.");
        [self.locationManager startRangingBeaconsInRegion:tempRegion];
    }
}


- (void) stopReceiver {
    for (CLBeaconRegion *reg in self.regions)
    {
        [self.locationManager stopMonitoringForRegion:reg];
        [self.locationManager stopRangingBeaconsInRegion:reg];
    }
    [self.regions removeAllObjects];
}

#pragma location monitor region delegate

- (void) locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
               withError:(NSError *)error
{
    NSLog(@"rangingBeaconsDidFailForRegion %@.", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Location services are not enabled.");
        return;
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        
        NSLog(@"Location services not authorised.");
        return;
    }
}

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Monitor started, request state for region:%@.",region);
    [self.locationManager requestStateForRegion:region];
}


- (void) locationManager:(CLLocationManager *)manager
       didDetermineState:(CLRegionState)state
               forRegion:(CLRegion *)region {
    NSString *stateString = nil;
    switch (state) {
        case CLRegionStateInside:
            stateString = @"inside";
            break;
        case CLRegionStateOutside:
            stateString = @"outside";
            break;
        case CLRegionStateUnknown:
            stateString = @"unknown";
            break;
    }
    
    NSLog(@"State changed to %@ for region %@.", stateString, region);
}


- (void) locationManager:(CLLocationManager *)manager
          didEnterRegion:(CLRegion *)region {

    NSLog(@"Entered region: %@", region);
    
//    [self sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region];
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void) locationManager:(CLLocationManager *)manager
           didExitRegion:(CLRegion *)region {

    NSLog(@"Exited region: %@", region);
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [manager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

#pragma location ranging beacon in region delegate

- (void) locationManager:(CLLocationManager *)manager
         didRangeBeacons:(NSArray *)beacons
                inRegion:(CLBeaconRegion *)region
{
    NSMutableString *data = [NSMutableString stringWithString:@""];
    for (CLBeacon *beacon in beacons) {
        [data appendFormat:@"%@,%d,%d,%d,%ld,%f;",beacon.proximityUUID.UUIDString, beacon.major.intValue, beacon.minor.intValue, (int)beacon.proximity, (long)beacon.rssi,beacon.accuracy];
    }
    //NSLog(@"IOS: Sending %@",data);
    UnitySendMessage("IBeaconReceiver","RangeBeacons",[[NSString stringWithString:data] cStringUsingEncoding:NSUTF8StringEncoding]);
}


@end
#pragma  export extern C API

bool initReceiver()
{
    IBeaconReceiver* receiver = [IBeaconReceiver getSharedBeaconReceiver];
    
    BOOL requires_avilable = [receiver checkDeviceAvilable];
    if (!requires_avilable) {
        return NO;
    }
    return YES;
}

/**
 * Testing Without Entering or Exiting the Region
 *
 * If you don’t want to leave your home briefly each time you want to test, 
 * set the simulateRegionEnterd = YES, it will start ranging the beacon immediately
 */
void startReceiveBeacon(char * uuid, bool simulateRegionEntered) {
    
    IBeaconReceiver* receiver = [IBeaconReceiver getSharedBeaconReceiver];

    [receiver startReceiveBeaconWithUUID:[[NSUUID alloc] initWithUUIDString:[NSString stringWithUTF8String:uuid]]
               shouldSimulateRegionEnter:simulateRegionEntered];
}

void stopReceiveAll() {
    [[IBeaconReceiver getSharedBeaconReceiver] stopReceiver];
}

