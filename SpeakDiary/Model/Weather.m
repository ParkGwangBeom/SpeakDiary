//
//  Weather.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import "Weather.h"

@implementation Weather

+(Weather *)sharedGPSModel{
    static Weather *sharedInstance = nil;
    
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

-(NSString *)getWeaderData{
    NSString *imageString;
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[GPSModel sharedGPSModel].lat longitude:[GPSModel sharedGPSModel].lng];
//    NSDictionary *dic_Data = [Util getWeatherForLocation:location];
    NSString *strWeather = NULL_TO_EMPTY_STRING(self.dicWeather[@"txt_forecast"][@"forecastday"][0][@"icon"]);
    //nt 없는지 체크
    if([strWeather isEqualToString:@"clear"]){
        self.weaderType = 1;
        imageString = @"icn_Sun_Write.png";
    }else if([strWeather isEqualToString:@"partlycloudy"]){
        self.weaderType = 2;
        imageString = @"icn_Cloud_Write.png";
    }else if([strWeather isEqualToString:@"chancerain"]){
        //비
        self.weaderType = 3;
        imageString = @"icn_Rain_Write.png";
    }else if([strWeather isEqualToString:@"nt_chancetstorms"]){
        self.weaderType = 4;
        imageString = @"icn_Sun_Write.png";
    }else{
        self.weaderType = 1;
        imageString = @"icn_Sun_Write.png";
    }
    return imageString;
}

-(NSString *)getWeaderWithString{
    NSString *imageString;
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[GPSModel sharedGPSModel].lat longitude:[GPSModel sharedGPSModel].lng];
    //    NSDictionary *dic_Data = [Util getWeatherForLocation:location];
    NSString *strWeather = NULL_TO_EMPTY_STRING(self.dicWeather[@"txt_forecast"][@"forecastday"][0][@"icon"]);
    //nt 없는지 체크
    if([strWeather isEqualToString:@"clear"]){
        imageString = @"맑음";
    }else if([strWeather isEqualToString:@"partlycloudy"]){
        self.weaderType = 2;
        imageString = @"구름 많음";
    }else if([strWeather isEqualToString:@"chancerain"]){
        //비
        self.weaderType = 3;
        imageString = @"비 내림";
    }else if([strWeather isEqualToString:@"nt_chancetstorms"]){
        self.weaderType = 4;
        imageString = @"태풍";
    }else{
        self.weaderType = 1;
        imageString = @"맑음";
    }
    return imageString;
}

-(void)getWeatherForLocation:(CLLocation*)location success:(void(^)(void))success fail:(void(^)(void))fail{
    NSString *strUrl=[NSString stringWithFormat:@"http://api.wunderground.com/api/131bad95922617dc/geolookup/forecast10day/q/%f,%f.json",location.coordinate.latitude,location.coordinate.longitude];
    
    NSString *escapedUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:escapedUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id item) {
        self.dicWeather = item[@"forecast"];
        NSLog(@"dicdic - %@",self.dicWeather);
        [GPSModel sharedGPSModel].addr = NULL_TO_EMPTY_STRING(item[@"location"][@"city"]);
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", error);
    }];
}

@end
