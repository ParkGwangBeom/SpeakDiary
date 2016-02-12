//
//  SD_SettingVC.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import "SD_SettingVC.h"

#import "JKLLockScreenViewController.h"

#import "Weather.h"

@interface SD_SettingVC ()<JKLLockScreenViewControllerDataSource, JKLLockScreenViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iv_Background;
@property (weak, nonatomic) IBOutlet UISwitch *Switch;
@property (weak, nonatomic) IBOutlet UISwitch *touchSwitch;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (weak, nonatomic) IBOutlet UIView *VersionView;

@end

@implementation SD_SettingVC

- (void)viewDidLoad {
    self.iv_Background.image = [UIImage imageNamed:[Weather sharedGPSModel].backgroundImage];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.Switch.on = [defaults boolForKey:DEF_USE_PASSWORD];
    if(self.Switch.isOn){
        self.touchView.hidden = NO;
        
    }else{
        self.touchView.hidden = YES;
        self.touchView.frameHeight = 0;
        self.VersionView.frameY = self.touchView.frameBottom + 34.0f;
    }
    self.touchSwitch.on = [defaults boolForKey:DEF_USE_TOUCH];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTouchBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchSlide:(id)sender {
    NSString *strToast;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(self.Switch.isOn){
        JKLLockScreenViewController * viewController = [[JKLLockScreenViewController alloc] initWithNibName:NSStringFromClass([JKLLockScreenViewController class]) bundle:nil];
        [viewController setLockScreenMode:LockScreenModeNew];    // enum { LockScreenModeNormal, LockScreenModeNew, LockScreenModeChange }
        
        //verification == 처음 화면에서 써야될것
        //change, new == 비밀번호 지정할때 써야될것
        
        [viewController setDelegate:self];
        [viewController setDataSource:self];
        [defaults setBool:YES forKey:DEF_USE_PASSWORD];
        [defaults synchronize];
        [self presentViewController:viewController animated:YES completion:^{
//            NSString *string = @"비밀번호가 설정되었습니다.";
//            [Util showToast:string];
        }];
        
    }else{
        strToast = @"비밀번호가 해제되었습니다.";
        [defaults setBool:NO forKey:DEF_USE_PASSWORD];
        [defaults synchronize];
        [Util showToast:strToast];
        self.touchView.hidden = YES;
        self.touchView.frameHeight =0.0f;
        self.VersionView.frameY = self.touchView.frameBottom + 34.0f;
    }
}
- (IBAction)touchSlideTouch:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(self.touchSwitch.isOn){
        [Util showToast:@"터치스크린을 사용합니다."];
        [defaults setBool:YES forKey:DEF_USE_TOUCH];
        [defaults synchronize];
    }else{
        
        [defaults setBool:NO forKey:DEF_USE_TOUCH];
        [defaults synchronize];

        [Util showToast:@"터치스크린을 해제합니다.."];
    }
}

- (BOOL)lockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController pincode:(NSString *)pincode{
    NSLog(@"언제");
    return YES;
}
- (BOOL)allowTouchIDLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController{
    return NO;
}

- (void)unlockWasSuccessfulLockScreenViewController:(JKLLockScreenViewController *)lockScreenViewController pincode:(NSString *)pincode{
    NSLog(@"%@",pincode);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pincode forKey:DEF_PASSWORD];
    [defaults setBool:YES forKey:DEF_USE_PASSWORD];
    [defaults synchronize];
    NSLog(@"pw - %@",[defaults objectForKey:DEF_PASSWORD]);
    self.touchView.hidden = NO;
    self.touchView.frameHeight =40.0f;
    self.VersionView.frameY = self.touchView.frameBottom + 34.0f;
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
