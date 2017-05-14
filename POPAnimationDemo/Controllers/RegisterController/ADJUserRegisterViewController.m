//
//  ADJUserRegisterViewController.m
//  POPAnimationDemo
//
//  Created by 张义 on 2017/5/10.
//  Copyright © 2017年 BearZ. All rights reserved.
//

#import "ADJUserRegisterViewController.h"
#import "UIColor+ACIHex.h"

@interface ADJUserRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *processContentView;
@property (weak, nonatomic) IBOutlet UIView *processView;
@property (weak, nonatomic) IBOutlet UIView *inputView1;
@property (weak, nonatomic) IBOutlet UIView *inputView2;
@property (weak, nonatomic) IBOutlet UIView *inputView3;
@property (weak, nonatomic) IBOutlet UIView *inputView4;
@property (weak, nonatomic) IBOutlet UIView *inputView5;


@end

@implementation ADJUserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Sign up";

    [self configProcessView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handler event
- (IBAction)upStepButtonClicked:(UIButton *)sender {
}

- (IBAction)nextStepButtonClicked:(UIButton *)sender {
}

#pragma mark -  private method
- (void)configProcessView {

    self.processContentView.layer.cornerRadius = 5.f;    
    self.processView.layer.cornerRadius = 4.f;
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
