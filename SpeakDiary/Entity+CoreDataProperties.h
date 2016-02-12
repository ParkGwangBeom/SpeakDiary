//
//  Entity+CoreDataProperties.h
//  
//
//  Created by 광범 on 2015. 8. 29..
//
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Entity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *addr;
@property (nullable, nonatomic, retain) NSNumber *bgm;
@property (nullable, nonatomic, retain) NSNumber *date;
@property (nullable, nonatomic, retain) NSNumber *emoticon;
@property (nullable, nonatomic, retain) NSNumber *month;
@property (nullable, nonatomic, retain) NSData *recode;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *weader;
@property (nullable, nonatomic, retain) NSNumber *year;
@property (nullable, nonatomic, retain) NSString *recodePath;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *imagePath;
@property (nullable, nonatomic, retain) NSNumber *day;
@property (nullable, nonatomic, retain) NSString *bgmName;
@property (nullable, nonatomic, retain) NSString *bgImageName;

@end

NS_ASSUME_NONNULL_END
