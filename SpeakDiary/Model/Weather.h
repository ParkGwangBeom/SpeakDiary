//
//  Weather.h
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, assign) NSInteger weaderType;
@property (nonatomic, strong) NSString *stringImage;
@property (nonatomic, strong) NSDictionary *dicWeather;
@property (nonatomic, strong) NSString *backgroundImage;

+(Weather *)sharedGPSModel;
-(NSString *)getWeaderData;
-(void)getWeatherForLocation:(CLLocation*)location success:(void(^)(void))success fail:(void(^)(void))fail;
-(NSString *)getWeaderWithString;
@end
