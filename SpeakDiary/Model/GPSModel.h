//
//  GPSModel.h
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface GPSModel : NSObject<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    
}

@property (nonatomic, strong) void(^blockLocationWithSuccessAndFail)(BOOL, NSError *);
@property (nonatomic, assign) BOOL isGPS;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;

+(GPSModel *)sharedGPSModel;
-(void)setLocationManager;

@end
