//
//  SD_WriteVC.h
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Entity.h"

@interface SD_WriteVC : UIViewController

@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) Entity *entitiy;

@end
