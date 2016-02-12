//
//  EmoticonView.m
//  SpeakDiary
//
//  Created by 광범 on 2015. 8. 29..
//  Copyright © 2015년 박광범. All rights reserved.
//

#import "EmoticonView.h"

#import "UIViewController+CWPopup.h"

@interface EmoticonView ()

@end

@implementation EmoticonView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnTouchClose:(id)sender {
    [self.delegate PopupClose];
}

- (IBAction)btnTouchEmoticon:(UIButton *)sender {
    [self.delegate clickEmoticon:sender.tag];
    [self dismissPopupViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
