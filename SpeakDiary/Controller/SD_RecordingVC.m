//
//  SD_RecordingVC.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import "SD_RecordingVC.h"

#import "SD_WriteVC.h"

#import <AVFoundation/AVFoundation.h>

#import "SCSiriWaveformView.h"

#import "Weather.h"

typedef NS_ENUM(NSUInteger, SCSiriWaveformViewInputType) {
    SCSiriWaveformViewInputTypeRecorder,
    SCSiriWaveformViewInputTypePlayer
};

@interface SD_RecordingVC ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSMutableArray *recordingFiles;
    
    NSString *filePath;
    
    BOOL    isRecording;
    __weak IBOutlet UILabel *lb_Timer;
    
    NSTimer *timer;
    
    int timeSec;
    int timeMin;
}

@property (weak, nonatomic) IBOutlet UIImageView *iv_Background;
@property (nonatomic) NSTimeInterval *initialTime;
@property (nonatomic) NSTimeInterval *timeobject;
@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIView *StartView;
@property (weak, nonatomic) IBOutlet UILabel *lb_Timer;
@property (weak, nonatomic) IBOutlet SCSiriWaveformView *waveformView;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Weather;
@property (weak, nonatomic) IBOutlet UIView *InStartView;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Record;
@property (weak, nonatomic) IBOutlet UILabel *lb_Content;
@property (weak, nonatomic) IBOutlet UILabel *lb_Content2;
@property (weak, nonatomic) IBOutlet UIButton *btn_Pause;
@property (weak, nonatomic) IBOutlet UILabel *lb_Top;

@property (nonatomic, assign) SCSiriWaveformViewInputType selectedInputType;


@end

@implementation SD_RecordingVC

//다큐먼트 폴더의 파일의 경로
-(NSString *)getPullPath:(NSString *)fileName{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:fileName];
}


- (void)viewDidLoad {
    self.iv_Background.image = [UIImage imageNamed:[Weather sharedGPSModel].backgroundImage];
    timeSec = 0;
    timeMin = 0;
    isRecording = NO;
    [Util applyRoundCornerWithView:self.StartView cornerRadius:115.0f];
    [Util applyRoundCornerWithView:self.recordPauseButton cornerRadius:110.0f];
    [Util applyRoundCornerWithView:self.InStartView cornerRadius:110.0f];
    
    self.StartView.layer.borderWidth = 1.0f;
    self.StartView.layer.borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    
    [self setWeather];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *date = [NSDate date];
    filePath = [self getPullPath:[NSString stringWithFormat:@"%@.caf",[date description]]];
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               filePath,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    //파일path목록
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    __autoreleasing NSError *error = nil;
    
    recordingFiles = [[NSMutableArray alloc]initWithArray:[fm contentsOfDirectoryAtPath:documentPath error:&error]];
    
    [self setBaseView];
}

-(void)setBaseView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Events
- (IBAction)btnTouchBack:(id)sender {
    if(isRecording){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (success) {
//            UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
//            [removeSuccessFulAlert show];
        }
        else{
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recordPauseTapped:(id)sender {
//     Stop the audio player before recording
    isRecording = YES;
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        self.InStartView.hidden = NO;

        [self setSelectedInputType:SCSiriWaveformViewInputTypeRecorder];
        [self viewanimation:self.iv_Record];
        [self.btn_Pause setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
        [self StartTimer];
    } else {
        // Pause recording
        [self.btn_Pause setImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
        [recorder pause];
        [timer invalidate];
    }
    
    [self.stopButton setEnabled:YES];
//    [playButton setEnabled:NO];
}

-(void)viewanimation:(UIView *)inView{
    self.lb_Content.hidden = YES;
    self.lb_Content2.hidden = YES;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.lb_Top.text = @"당신의 이야기를 들려주세요.";
        self.iv_Record.alpha = 0.0f;
        self.iv_Record.transform = CGAffineTransformMakeScale(5.0, 5.0);
    } completion:^(BOOL finished){
        self.iv_Record.hidden = YES;
        self.lb_Timer.hidden = NO;
        self.btn_Pause.hidden = NO;
    }];

}

- (IBAction)btnPause:(id)sender {
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        
        [self.btn_Pause setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
        [self StartTimer];
    } else {
        // Pause recording
        [self.btn_Pause setImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
        [recorder pause];
        [timer invalidate];
    }
}

- (IBAction)stopTapped:(id)sender {
    if(isRecording == NO){
        [Util showToast:@"녹음하여주세요"];
        return;
    }
    [recorder stop];

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    SD_WriteVC *writeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SD_WriteVCID"];
    writeVC.isEdit = NO;
    writeVC.path = filePath;
    [self.navigationController pushViewController:writeVC animated:YES];
}

- (IBAction)play:(id)sender {
    if (!recorder.recording){
        NSLog(@"----- %@",recorder.url);
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}

// 타이머
-(void) StartTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
//Event called every time the NSTimer ticks.
- (void)timerTick:(NSTimer *)timer
{
    timeSec++;
    if (timeSec == 60)
    {
        timeSec = 0;
        timeMin++;
    }
    //Format the string 00:00
    NSString* timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMin, timeSec];
    //Display on your label
    //[timeLabel setStringValue:timeNow];
    self.lb_Timer.text= timeNow;
}

-(void)setWeather{
    UIImage *weatherImage;
    if([Weather sharedGPSModel].weaderType == 1){
        weatherImage = [UIImage imageNamed:@"icn_Sun_Big.png"];
    }else if([Weather sharedGPSModel].weaderType == 2){
        weatherImage = [UIImage imageNamed:@"icn_Rain_Big.png"];
    }else if([Weather sharedGPSModel].weaderType == 3){
        weatherImage = [UIImage imageNamed:@"icn_Cloud_Big.png"];
    }else if([Weather sharedGPSModel].weaderType == 4){
        weatherImage = [UIImage imageNamed:@"icn_Sun_Big.png"];
    }else{
        weatherImage = [UIImage imageNamed:@"icn_Sun_Big.png"];
    }
    self.iv_Weather.image = weatherImage;
}
@end
