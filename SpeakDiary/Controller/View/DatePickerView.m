//
//  DatePickerView.m
//  RightNowClient
//
//  Created by 광범 on 2015. 8. 19..
//  Copyright (c) 2015년 박광범. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@end

@implementation DatePickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Events
- (IBAction)btnTouch:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(setDate:)]){
        [self.delegate setDate:self.datePickerView.date];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
