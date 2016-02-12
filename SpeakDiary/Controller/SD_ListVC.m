//
//  SD_ListVC.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import "SD_ListVC.h"

#import "DiaryListCell.h"

#import "EmoticonView.h"

#import "UIViewController+CWPopup.h"

#import "Entity.h"

#import "SD_DetailVC.h"

#import "GPSModel.h"

#import "Weather.h"

#import "JKLLockScreenViewController.h"

#import "Emoticon.h"

#import "SD_SettingVC.h"

@interface SD_ListVC ()<UITableViewDataSource, UITableViewDelegate, EmoticonViewDelegate, JKLLockScreenViewControllerDelegate, JKLLockScreenViewControllerDataSource>{
    NSInteger day;
    NSInteger month;
    NSInteger year;
    
    NSDate *currentDate;
}

@property (nonatomic, strong) NSArray *arr_List;
@property (weak, nonatomic) IBOutlet UITableView *tv_List;
@property (weak, nonatomic) IBOutlet UILabel *lb_Year;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Background;
@property (weak, nonatomic) IBOutlet UIButton *btn_Emoticon;
@property (weak, nonatomic) IBOutlet UILabel *lb_Month;
@property (weak, nonatomic) IBOutlet UIView *EmoticonView;

@property (nonatomic, strong) GPSModel *gpsModel;

@end

@implementation SD_ListVC
-(void)getCurrentDate{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    day = [components day];
    month = [components month];
    year = [components year];
    
    currentDate = [NSDate date];
    self.lb_Month.text = [NSString stringWithFormat:@"%ld월", month];
    self.lb_Year.text = [NSString stringWithFormat:@"%ld년",year];

    [self setDataWithDate:month year:year];
}

- (void)viewDidLoad {
    [Weather sharedGPSModel].backgroundImage = @"bg_0.png";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:DEF_FIRST];
    [defaults synchronize];
    if([defaults boolForKey:DEF_USE_PASSWORD]){
        JKLLockScreenViewController * viewController = [[JKLLockScreenViewController alloc] initWithNibName:NSStringFromClass([JKLLockScreenViewController class]) bundle:nil];
        [viewController setLockScreenMode:LockScreenModeNormal];    // enum
        [viewController setDelegate:self];
        [viewController setDataSource:self];
        [self presentViewController:viewController animated:YES completion:NULL];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _gpsModel = [GPSModel sharedGPSModel];
    [_gpsModel setLocationManager];
    [self getMyLocation];
    
    [self setEntitiy];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCurrentDate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//CoreData
-(void)setEntitiy{
    self.arr_List = [Entity MR_findAll];
    [self.tv_List reloadData];
}

-(void)setDataWithDate:(NSInteger)monte year:(NSInteger)year{
    NSPredicate *bankPredicate = [NSPredicate predicateWithFormat:@"month = %ld and year = %ld", monte, year];
    self.arr_List= [Entity MR_findAllWithPredicate:bankPredicate];
    if(self.arr_List.count > 0){
        self.EmoticonView.hidden = NO;
    }else{
        self.EmoticonView.hidden = YES;
    }
    [self.tv_List reloadData];
}

-(void)setEmoticonWithType:(NSInteger)type{
    NSPredicate *bankPredicate = [NSPredicate predicateWithFormat:@"emoticon = %ld", type];
    self.arr_List= [Entity MR_findAllWithPredicate:bankPredicate];
    [self.tv_List reloadData];
}

//GPS
-(void)getMyLocation{
    __weak SD_ListVC *weakeSelf = self;
    _gpsModel.blockLocationWithSuccessAndFail = ^(BOOL isSuccess, NSError *error){
        __strong SD_ListVC *strongSelf = weakeSelf;
        if(isSuccess){
            [strongSelf requestWeader];
        }else{
            NSLog(@"실패");
        }
    };
}

-(void)requestWeader{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[GPSModel sharedGPSModel].lat longitude:[GPSModel sharedGPSModel].lng];
    [[Weather sharedGPSModel] getWeatherForLocation:location success:^{
        NSLog(@"weatherImage - %@",[[Weather sharedGPSModel]getWeaderData]);
        NSInteger rand;
        if([Weather sharedGPSModel].weaderType == 1){
            rand = arc4random() % 2;
        }else if([Weather sharedGPSModel].weaderType == 2){
            rand = arc4random() % 2;
        }else if([Weather sharedGPSModel].weaderType == 3){
            rand = arc4random() % 3;
        }else if([Weather sharedGPSModel].weaderType == 4){
            rand = arc4random() % 2;
        }else{
            rand = arc4random() % 2;
        }
        
        NSString *imageString = [NSString stringWithFormat:@"bg_%ld_%ld.png",[Weather sharedGPSModel].weaderType, rand];
        NSLog(@"배경 - %@",imageString);
        [self.iv_Background setImage:[UIImage imageNamed:imageString]];
        [Weather sharedGPSModel].backgroundImage = imageString;
    } fail:^{
       
    }];
}


#pragma mark - IBAction Events
- (IBAction)btnTouchPrevios:(id)sender {
    [self getMonthWithMonth:-1];
}

- (IBAction)btnTouchNext:(id)sender {
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if([today month] == [otherDay month] &&
       [today year] == [otherDay year]){
        return;
    }
    [self getMonthWithMonth:1];
}
- (IBAction)btnTouchEmoticon:(id)sender {
    EmoticonView *emoticonView = [self.storyboard instantiateViewControllerWithIdentifier:@"EmoticonViewID"];
    emoticonView.delegate = self;
    emoticonView.view.frame = CGRectMake(25.0f, 200.0f, 280.0f, 200.0f);
    [self presentPopupViewController:emoticonView animated:YES completion:nil];
}
- (IBAction)btnTouchGoSetting:(id)sender {
    SD_SettingVC *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SD_SettingVCID"];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (IBAction)btnTouchGoRecoding:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SD_RecordingVCID"];
    [self.navigationController pushViewController:vc animated:YES];
}





#pragma mark - Data Setting
-(void)getMonthWithMonth:(NSInteger)monthInteger{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:monthInteger];
    currentDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    [self setDayLabel:currentDate];
}

-(void)setDayLabel:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    self.lb_Month.text = [NSString stringWithFormat:@"%ld월",[components month]];
    self.lb_Year.text = [NSString stringWithFormat:@"%ld년",[components year]];
    [self setDataWithDate:[components month] year:[components year]];
}

#pragma mark - UITableview Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arr_List count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DiaryListCellID";
    DiaryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Entity *entitiy = self.arr_List[indexPath.row];
    [cell configureCell:entitiy row:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SD_DetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SD_DetailVCID"];
    Entity *entitiy = self.arr_List[indexPath.row];
    detailVC.entitiy = entitiy;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - EmoticonDelegate
-(void)clickEmoticon:(NSInteger)emoticonType{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        [self.btn_Emoticon setImage:[UIImage imageNamed:[Emoticon getEmoticonString:emoticonType]]  forState:UIControlStateNormal];
        [self setEmoticonWithType:emoticonType];
    }];
}

-(void)PopupClose{
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - PW delegate
- (BOOL)lockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController pincode:(NSString *)pincode{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([pincode isEqualToString:[defaults objectForKey:DEF_PASSWORD]]){

    }else{
        [Util showToast:@"비밀번호가 틀렸습니다."];
    }
        
    return [pincode isEqualToString:[defaults objectForKey:DEF_PASSWORD]];
}
- (BOOL)allowTouchIDLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:DEF_USE_TOUCH];
}

- (void)unlockWasSuccessfulLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController pincode:(NSString *)pincode{
    NSLog(@"%@",pincode);
}
- (void)unlockWasSuccessfulLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController{
    NSLog(@"뭐지");
}
- (void)unlockWasCancelledLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController{
    //취소눌렀을때
}

- (void)unlockWasFailureLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController{
    [Util showToast:@"비밀번호가 틀렸습니다."];
}
@end
