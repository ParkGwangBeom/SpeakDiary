//
//  MusicListView.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import "MusicListView.h"

#import "MusicListCell.h"

#import <AVFoundation/AVFoundation.h>

@interface MusicListView ()<UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>{
    NSMutableArray *fileList;
    NSArray *filePathsArray;
    NSInteger selectItem;
    NSString *stringName;
    AVAudioPlayer *player;
    NSString *documentsDirectory;
    NSMutableArray *arr_MusicData;
}
@property (weak, nonatomic) IBOutlet UITableView *tv_List;

@end

@implementation MusicListView

-(void)playerStart:(NSInteger)row{
    player = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[filePathsArray objectAtIndex:row]];
    
    NSURL *outputFileURL = [NSURL fileURLWithPath:filePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:outputFileURL error:nil];
    [player setDelegate:self];
//    [player setVolume:1];
    
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    //error handling
    BOOL success;
    NSError* error;
    
    //set the audioSession category.
    //Needs to be Record or PlayAndRecord to use audioRouteOverride:
    
    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                             error:&error];
    
    if (!success)  NSLog(@"AVAudioSession error setting category:%@",error);
    
    //set the audioSession override
    success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                         error:&error];
    if (!success)  NSLog(@"AVAudioSession error overrideOutputAudioPort:%@",error);
    
    //activate the audio session
    success = [session setActive:YES error:&error];
    if (!success) NSLog(@"AVAudioSession error activating: %@",error);
    else NSLog(@"audioSession active");
    
    
    [player prepareToPlay];
    [player play];
}

- (void)viewDidLoad {
    arr_MusicData = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory;
    documentsDirectory = [paths objectAtIndex:0];
    
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyFolder"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    fileList = [manager directoryContentsAtPath:documentsDirectory];
    
    filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    for(NSString *st in filePathsArray){
        NSArray *arr = [st componentsSeparatedByString:@"."];
        if(![[arr lastObject] isEqualToString:@"caf"]){
            [arr_MusicData addObject:st];
        }
    }
    
    NSLog(@"files array %@", filePathsArray);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnTouchClose:(id)sender {
    [player stop];
    [self.delegate PopupClose];
}

- (IBAction)btnTouchOK:(id)sender {
    if([stringName isEqualToString:@""]){
        [Util showToast:@"배경음을 선택해주세요."];
        return;
    }
    [player stop];
    [self.delegate clickMusic:stringName];
}
#pragma mark - UITableviewDelegate & UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [filePathsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicListCellID"];
    [cell configureCell:filePathsArray[indexPath.row] row:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    stringName = filePathsArray[indexPath.row];
    [self playerStart:indexPath.row];
}

@end
