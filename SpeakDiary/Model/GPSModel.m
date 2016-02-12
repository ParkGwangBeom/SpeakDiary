//
//  GPSModel.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import "GPSModel.h"

@implementation GPSModel

+(GPSModel *)sharedGPSModel{
    static GPSModel *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if(self){

    }
    return self;
}

-(void)setLocationManager{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ) {
//        self.lat = kDefaultLat;
//        self.lng = kDefaultLng;
    }else{
        if (locationManager == nil) {
            locationManager= [[CLLocationManager alloc] init];
            
            locationManager.distanceFilter = 2000.0f;
            locationManager.delegate= self;
            locationManager.desiredAccuracy= kCLLocationAccuracyBest;
            if(IS_OS_8_OR_LATER) {
                if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [locationManager requestWhenInUseAuthorization];
                    
                    [locationManager startMonitoringSignificantLocationChanges];
                }
            }
        }
        _isGPS = NO;
        [locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    //    _currentLocation = newLocation;
    if(!_isGPS){
        self.lat = newLocation.coordinate.latitude;
        self.lng = newLocation.coordinate.longitude;
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        if(self.blockLocationWithSuccessAndFail){
            self.blockLocationWithSuccessAndFail(YES, nil);
        }
        
        [locationManager stopMonitoringSignificantLocationChanges];
        [locationManager stopUpdatingLocation];
        _isGPS = YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(self.blockLocationWithSuccessAndFail){
        self.blockLocationWithSuccessAndFail(NO, error);
    }
}


@end
