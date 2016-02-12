//
//  SD_DetailVC.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import "SD_DetailVC.h"

#import "SD_WriteVC.h"

#import <AVFoundation/AVFoundation.h>

#import "Weather.h"
#import "Emoticon.h"
@interface SD_DetailVC ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate, UIAlertViewDelegate>{
    AVAudioPlayer *player1;
    AVAudioRecorder *recorder;
    AVAudioPlayer *playerBGM;
    NSString *documentsDirectory;
    NSMutableArray *theFiles;
    NSMutableArray *fileList;
    NSTimer *playbackTimer;
    float volume;
}
@property (weak, nonatomic) IBOutlet UILabel *lb_Title;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Emoticon;
@property (weak, nonatomic) IBOutlet UILabel *lb_Content;
@property (weak, nonatomic) IBOutlet UILabel *lb_Date;
@property (weak, nonatomic) IBOutlet UILabel *lb_Bgm;
@property (weak, nonatomic) IBOutlet UIButton *btn_Volume;
@property (weak, nonatomic) IBOutlet UILabel *lb_EndTimer;
@property (weak, nonatomic) IBOutlet UIProgressView *ProgreeBar;
@property (weak, nonatomic) IBOutlet UILabel *lb_StartTimer;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Background;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Background2;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SD_DetailVC
#pragma mark - Gesture
- (void)ChatViewTap:(id)Sender{
    NSInteger randInt = arc4random() % 8;
    NSString *imageBG = [NSString stringWithFormat:@"bg_%ld.png",randInt];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Entity *entitiy = self.entitiy;
        entitiy.bgImageName = imageBG;
    } completion:^(BOOL success, NSError *error) {
        if(success){
            
        }
    }];
    [self.iv_Background2 setImage:[UIImage imageNamed:imageBG]];
    [self setBackgroundImageAnimation];
}

-(void)setBackgroundImageAnimation{
    [UIView animateWithDuration:0.8 animations:^{
        self.iv_Background2.alpha = 1.0f;
        self.iv_Background.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.iv_Background.image = self.iv_Background2.image;
        self.iv_Background.alpha = 1.0f;
        self.iv_Background2.alpha = 0;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(ChatViewTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    playbackTimer=[NSTimer scheduledTimerWithTimeInterval:0.5
                                                   target:self
                                                 selector:@selector(myMethod:)
                                                 userInfo:nil
                                                  repeats:YES];
    

    // Do any additional setup after loading the view.
    
    if ([self.entitiy.bgImageName isEqualToString:@""]) {
        self.iv_Background.image = [UIImage imageNamed:[Weather sharedGPSModel].backgroundImage];
    }else{
        [self.iv_Background setImage:[UIImage imageNamed:self.entitiy.bgImageName]];
    }
    
    NSLog(@"배경이미지이름 %@",self.entitiy.bgImageName);
    
    [self playerStart];
    [self setBaseView];
    [self music];
    
    self.lb_Date.text = [NSString stringWithFormat:@"%@.%@.%@",self.entitiy.year, self.entitiy.month, self.entitiy.day];
    self.lb_Bgm.text = self.entitiy.bgmName;
    [self setWeatherImage:self.entitiy];
    
    
}

-(void)myMethod:(NSTimer*)timer {
    
    float total=playerBGM.duration;
    float f=playerBGM.currentTime / total;
    
    NSString *str = [NSString stringWithFormat:@"%f", f];
    
    self.ProgreeBar.progress=f;
    
}

-(void)setWeatherImage:(Entity *)item{
    self.iv_Emoticon.image = [UIImage imageNamed:[Emoticon getBigEmoticonString:[item.emoticon integerValue]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTimeLeft {
//    NSTimeInterval timeLeft = self.player.duration - self.player.currentTime;
//    
//    // update your UI with timeLeft
//    self.lb_StartTimer.text = [NSString stringWithFormat:@"%f seconds left", timeLeft];
}

-(void)playerStart{
    NSURL *outputFileURL = [NSURL fileURLWithPath:self.entitiy.recodePath];
    NSLog(@"output - %@",outputFileURL);
    player1 = [[AVAudioPlayer alloc] initWithContentsOfURL:outputFileURL error:nil];
    [self setAudioSession];
    [player1 setDelegate:self];
    [player1 setVolume:1];
//    [player1 prepareToPlay];
    [player1 play];
    
}

- (void)updateTime
{
    NSTimeInterval currentTime = playerBGM.currentTime;
    
    NSInteger minutes = floor(currentTime/60);
    NSInteger seconds = trunc(currentTime - minutes * 60);
    
    // update your UI with currentTime;
    self.lb_StartTimer.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (void)updateEndTime
{
    NSTimeInterval currentTime = playerBGM.duration;
    
    NSInteger minutes = floor(currentTime/60);
    NSInteger seconds = trunc(currentTime - minutes * 60);
    
    // update your UI with currentTime;
    self.lb_EndTimer.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

-(void)setBaseView{
    volume = 0.1f;
    self.lb_Content.text = self.entitiy.text;
    self.lb_Title.text = self.entitiy.title;
}


-(void)music{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    __block NSInteger integer;
    [filePathsArray enumerateObjectsUsingBlock:^(NSString *musicString, NSUInteger idx, BOOL *stop) {
        if([musicString isEqualToString:self.entitiy.bgmName]){
            integer = idx;
        }
    }];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[filePathsArray objectAtIndex:integer]];
    
    NSURL *outputFileURL = [NSURL fileURLWithPath:filePath];
    NSLog(@"bgm - %@",outputFileURL);
    playerBGM = [[AVAudioPlayer alloc] initWithContentsOfURL:outputFileURL error:nil];
    
    [playerBGM setVolume: 0.1];
//    [playerBGM setDelegate:self];
    [self setAudioSession];
//    [playerBGM prepareToPlay];
    [playerBGM play];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [self updateEndTime];
}

- (void)setAudioSession{
    NSError *error = nil;
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryAmbient withOptions:kAudioSessionProperty_OverrideCategoryMixWithOthers error:&error];
    [session setActive:YES error:&error];
}

- (IBAction)btnTouchBack:(id)sender {
    [player1 stop];
    [playerBGM stop];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTouchSound:(id)sender {
    if(playerBGM.volume == 0){
        [player1 setVolume:1.0f];
        [playerBGM setVolume:volume];
        self.btn_Volume.selected = NO;
    }else{
        [player1 setVolume:0];
        [playerBGM setVolume:0];
        self.btn_Volume.selected = YES;
    }
}
- (IBAction)btnTouchDel:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"삭제" message:@"정말로 삭제 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"삭제", nil];
    [alert show];
}
- (IBAction)btnTouchEdit:(id)sender{
    [player1 stop];
    [playerBGM stop];
    SD_WriteVC *writeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SD_WriteVCID"];
    writeVC.entitiy = self.entitiy;
    writeVC.isEdit = YES;
    [self.navigationController pushViewController:writeVC animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != alertView.cancelButtonIndex){
        [self.entitiy MR_deleteEntity];
        [Util showToast:@"삭제되었습니다."];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if(player == player1 && flag == true){
        [playerBGM setVolume:0.3f];
        volume = 0.3f;
    }
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"%@",error);
}

@end
