//
//  SD_WriteVC.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import "SD_WriteVC.h"

#import "Entity.h"

#import "Weather.h"

#import "EmoticonView.h"

#import "UIViewController+CWPopup.h"

#import "MusicListView.h"

#import "LGSemiModalNavViewController.h"

#import "DatePickerView.h"

#import "Emoticon.h"

static NSString *const requestPlaceHolderString = @"내용을 입력해주세요";

@interface SD_WriteVC ()<UITextViewDelegate, EmoticonViewDelegate, MusicListViewDelegate, DatePickerViewDelegate>{
    NSInteger bgmInteger;
    NSInteger emoticonInteger;
    NSInteger   weatherInteger;
    NSString *musicNameString;
    long long milliseconds;
    NSString *addr;
    BOOL        isBGM;
}
@property (weak, nonatomic) IBOutlet UIImageView *iv_Background;
@property (weak, nonatomic) IBOutlet UILabel *lb_Weather;
@property (weak, nonatomic) IBOutlet UIImageView *iv_Weather;
@property (weak, nonatomic) IBOutlet UITextView *ContentTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITextField *tf_Title;
@property (weak, nonatomic) IBOutlet UIButton *btn_BGM;
@property (weak, nonatomic) IBOutlet UIButton *btn_Date;
@property (weak, nonatomic) IBOutlet UIButton *btn_Weather;
@property (weak, nonatomic) IBOutlet UIButton *btn_Emoticon;

@end

@implementation SD_WriteVC
#pragma mark - KeyBoardDelegate
- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *notificationDictionary = [notification userInfo];
    NSValue *keyValue = [notificationDictionary objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyValue CGRectValue].size;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.ScrollView.frameHeight = self.ScrollView.frameHeight - keyboardSize.height;
                     }
                     completion:^(BOOL finished) {
                     }];
    
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    NSDictionary *notificationDictionary = [notification userInfo];
    NSValue *keyValue = [notificationDictionary objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyValue CGRectValue].size;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.ScrollView.frameHeight = self.ScrollView.frameHeight + keyboardSize.height;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Gesture
- (void)ChatViewTap:(id)Sender{
    [Util hideKeyboard];
}

- (void)viewDidLoad {
    
    self.iv_Background.image = [UIImage imageNamed:[Weather sharedGPSModel].backgroundImage];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(ChatViewTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.ScrollView addGestureRecognizer:singleTap];
    
    if(self.isEdit){
        [self setEditView];
    }else{
        isBGM = NO;
        addr = [GPSModel sharedGPSModel].addr;
        weatherInteger = [Weather sharedGPSModel].weaderType;
        [self setBaseView];
        self.ContentTextView.text = requestPlaceHolderString;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.ScrollView setContentSize:CGSizeMake(self.view.frameWidth, self.ContentTextView.frameBottom + 30.0f)];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self deregisterForKeyboardNotifications];
}

- (void)deregisterForKeyboardNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [center removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setEditView{
    [self.btn_Date setTitle:[NSString stringWithFormat:@"%ld.%ld.%ld",[self.entitiy.year integerValue], [self.entitiy.month integerValue],[self.entitiy.day integerValue]] forState:UIControlStateNormal];
    [self.btn_BGM setTitle:self.entitiy.bgmName forState:UIControlStateNormal];
    self.tf_Title.text = self.entitiy.title;
    self.ContentTextView.text = self.entitiy.text;
    self.path = self.entitiy.recodePath;
    milliseconds = [self.entitiy.date longLongValue];
    emoticonInteger = [self.entitiy.emoticon integerValue];
    musicNameString = self.entitiy.bgmName;
    addr = self.entitiy.addr;
    weatherInteger = [self.entitiy.weader integerValue];
}

-(void)setBaseView{
    milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    [self.btn_Date setTitle:[NSString stringWithFormat:@"%ld.%ld.%ld",[Util getYear:milliseconds], [Util getMonth:milliseconds], [Util getDay:milliseconds]] forState:UIControlStateNormal];
    
    self.lb_Weather.text = [[Weather sharedGPSModel]getWeaderWithString];
    self.iv_Weather.image = [UIImage imageNamed:[[Weather sharedGPSModel] getWeaderData]];
    
    [self.btn_Weather setImage:[UIImage imageNamed:[[Weather sharedGPSModel]getWeaderData]] forState:UIControlStateDisabled];
    [self.btn_Weather setTitle:[[Weather sharedGPSModel] getWeaderWithString]forState:UIControlStateDisabled];
}

#pragma mark - IBAction Events
- (IBAction)btnTouchBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnTouchEmoticon:(id)sender {
    [Util hideKeyboard];
    EmoticonView *emoticonView = [self.storyboard instantiateViewControllerWithIdentifier:@"EmoticonViewID"];
    emoticonView.delegate = self;
    emoticonView.view.frame = CGRectMake(25.0f, 200.0f, 280.0f, 200.0f);
    [self presentPopupViewController:emoticonView animated:YES completion:nil];
}

- (IBAction)btnTouchDate:(id)sender {
    [Util hideKeyboard];
    DatePickerView *showVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePickerViewID"];
    showVC.delegate = self;
    LGSemiModalNavViewController *semiModal;
    if(semiModal == nil){
        semiModal = [[LGSemiModalNavViewController alloc]initWithRootViewController:showVC];
        semiModal.view.frame = CGRectMake(0.0f, 0.0f, self.view.frameWidth, 260);
        semiModal.navigationBarHidden = YES;
    }
    [self presentViewController:semiModal animated:YES completion:nil];
}
- (IBAction)btnTouchBGM:(id)sender {
    [Util hideKeyboard];
    MusicListView *emoticonView = [self.storyboard instantiateViewControllerWithIdentifier:@"MusicListViewID"];
    emoticonView.delegate = self;
    emoticonView.view.frame = CGRectMake(25.0f, 200.0f, 280.0f, 350.0f);
    [self presentPopupViewController:emoticonView animated:YES completion:nil];
}
- (IBAction)btnTouchSave:(id)sender {
    [Util hideKeyboard];
    
    if(self.tf_Title.text.length == 0){
        [Util showToast:@"제목을 입력해주세요!"];
        return;
    }
    if(self.ContentTextView.text.length == 0){
        [Util showToast:@"오늘 하루 일과를 적어보세요!"];
        return;
    }
    
    if(self.isEdit){
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Entity *entitiy = self.entitiy;
            entitiy.text = self.ContentTextView.text;
            entitiy.addr = addr;
            entitiy.date = [NSNumber numberWithLongLong:milliseconds];
            entitiy.month = [NSNumber numberWithInteger:[Util getMonth:milliseconds]];
            entitiy.year = [NSNumber numberWithInteger:[Util getYear:milliseconds]];
            entitiy.day = [NSNumber numberWithInteger:[Util getDay:milliseconds]];
            entitiy.bgm = [NSNumber numberWithInteger:bgmInteger];
            entitiy.emoticon = [NSNumber numberWithInteger:emoticonInteger];
            entitiy.recodePath = self.path;
            entitiy.weader = [NSNumber numberWithInteger:weatherInteger];
            entitiy.title = self.tf_Title.text;
            entitiy.bgmName = musicNameString;
            entitiy.bgImageName = @"";
        } completion:^(BOOL success, NSError *error) {
            [Util showToast:@"글이 수정되었습니다."];
            [self.navigationController popToRootViewControllerAnimated:YES];
            if(!success)
                NSLog(@"%@",error);
            else{
                
            }
            
        }];
    }else{
        if(!isBGM){
            [Util showToast:@"배경음을 골라보세요!"];
            return;
        }
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            //코어데이터 지역정보 사용여뷰 체크 후 사용하지 않았을 시 코어데이터에 새로운 데이터 값으로 저장
            Entity *entitiy = [Entity MR_createEntityInContext:localContext];
            entitiy.text = self.ContentTextView.text;
            entitiy.addr = addr;
            entitiy.date = [NSNumber numberWithLongLong:milliseconds];
            entitiy.month = [NSNumber numberWithInteger:[Util getMonth:milliseconds]];
            entitiy.year = [NSNumber numberWithInteger:[Util getYear:milliseconds]];
            entitiy.day = [NSNumber numberWithInteger:[Util getDay:milliseconds]];
            entitiy.bgm = [NSNumber numberWithInteger:bgmInteger];
            entitiy.emoticon = [NSNumber numberWithInteger:emoticonInteger];
            entitiy.recodePath = self.path;
            entitiy.weader = [NSNumber numberWithInteger:weatherInteger];
            entitiy.title = self.tf_Title.text;
            entitiy.bgmName = musicNameString;
            entitiy.bgImageName = @"";
        } completion:^(BOOL success, NSError *error) {
            if(!success){
                NSLog(@"실패");
            }else{
                [Util showToast:@"글이 작성되었습니다."];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
    
}

#pragma mark -
#pragma mark - Text Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:requestPlaceHolderString]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = requestPlaceHolderString;
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - EmoticonDelegate
-(void)clickEmoticon:(NSInteger)emoticonType{
    emoticonInteger = emoticonType;
    [self dismissPopupViewControllerAnimated:YES completion:^{
        [self.btn_Emoticon setImage:[UIImage imageNamed:[Emoticon getEmoticonString:emoticonType]]  forState:UIControlStateNormal];
    }];
}

-(void)PopupClose{
    [self dismissPopupViewControllerAnimated:YES completion:^{
       
    }];
}

#pragma mark - MusicDelegate
-(void)clickMusic:(NSString *)musicName{
    musicNameString = musicName;
    self.btn_BGM.titleLabel.text = musicName;
    isBGM = YES;
    [self dismissPopupViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - DatePickerViewDelegate
-(void)setDate:(NSDate *)date{
    milliseconds = (long long)([date timeIntervalSince1970] * 1000.0);
    [self.btn_Date setTitle:[NSString stringWithFormat:@"%ld.%ld.%ld",[Util getYear:milliseconds], [Util getMonth:milliseconds], [Util getDay:milliseconds]] forState:UIControlStateNormal];
}

@end
