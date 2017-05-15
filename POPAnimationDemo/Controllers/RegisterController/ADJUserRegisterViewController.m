//
//  ADJUserRegisterViewController.m
//  POPAnimationDemo
//
//  Created by 张义 on 2017/5/10.
//  Copyright © 2017年 BearZ. All rights reserved.
//

#import "ADJUserRegisterViewController.h"
#import "UIColor+ACIHex.h"
#import "POP.h"

#define processViewUnitLength (self.processContentView.frame.size.width - 2) / 5

@interface ADJUserRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *processContentView;
@property (weak, nonatomic) IBOutlet UIView *processView;
@property (weak, nonatomic) IBOutlet UIView *inputView1;
@property (weak, nonatomic) IBOutlet UIView *inputView2;
@property (weak, nonatomic) IBOutlet UIView *inputView3;
@property (weak, nonatomic) IBOutlet UIView *inputView4;
@property (weak, nonatomic) IBOutlet UIView *inputView5;

@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *upStepButton;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@end

@implementation ADJUserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Sign up";

    [self configProcessView];
    self.index = 1;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left_gray"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handler event
- (IBAction)upStepButtonClicked:(UIButton *)sender {
    
    if (self.index > 1) {
        [self transformUpStepInputView:self.index];
        self.index--;
        [self changeProcessViewAnimation:self.index];
    }
}

- (IBAction)nextStepButtonClicked:(UIButton *)sender {
    
    if (self.index < 5) {
        [self transformNextStepInputView:self.index];
        self.index++;
        [self changeProcessViewAnimation:self.index];
    }
    if (self.index == 5) {
        [self hiddenStepButton];
    }
}

- (IBAction)backgroundViewDidClicked:(UIControl *)sender {
    
    return;
}

#pragma mark -  private method
- (void)configProcessView {

    self.processContentView.layer.cornerRadius = 5.f;
    self.processContentView.layer.borderWidth = 1.f;
    self.processContentView.layer.borderColor = self.processContentView.backgroundColor.CGColor;
    self.processContentView.clipsToBounds = YES;
    self.processContentView.layer.masksToBounds = YES;
    self.processView.layer.cornerRadius = 4.f;
}
- (void)popBack {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeProcessViewAnimation:(NSInteger)index {

    POPSpringAnimation *ani_1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    CGFloat width = processViewUnitLength * index;
    ani_1.toValue = [NSValue valueWithCGSize:CGSizeMake(width, self.processView.frame.size.height)];
    ani_1.springSpeed = 5;
    ani_1.springBounciness = 10;
    [self.processView.layer pop_addAnimation:ani_1 forKey:@"ani_1"];
    POPSpringAnimation *ani_2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    ani_2.toValue = @(width / 2);
    ani_2.springSpeed = 5;
    ani_2.springBounciness = 10;
    [self.processView.layer pop_addAnimation:ani_2 forKey:@"ani_2"];
}

- (void)transformInputViewWithNextStepAnimationOffScreen:(UIView *)offscreenView OnScreen:(UIView *)onscreenView {

    CGFloat toValue = CGRectGetMidX(self.view.bounds);
    
    POPBasicAnimation *onscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    onscreenAnimation.fromValue = @(0);
    onscreenAnimation.toValue = @(1);
    onscreenAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeInAnimation];
    offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
    offscreenAnimation.toValue = @(-toValue);
    offscreenAnimation.duration = 0.3f;
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [onscreenView pop_addAnimation:onscreenAnimation forKey:@"onscreenAnimation"];
    }];
    [offscreenView pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
}

- (void)transformInputViewWithUpStepAnimationOffScreen:(UIView *)offscreenView OnScreen:(UIView *)onscreenView {

    CGFloat toValue = CGRectGetMidX(self.view.bounds);
    
    POPBasicAnimation *onscreenAnimation = [POPBasicAnimation easeInAnimation];
    onscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
    onscreenAnimation.toValue = @(toValue);
    onscreenAnimation.duration = 0.3f;
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    offscreenAnimation.fromValue = @(1);
    offscreenAnimation.toValue = @(0);
    offscreenAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    offscreenAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [onscreenView pop_addAnimation:onscreenAnimation forKey:@"onscreenAnimation"];
    };
    
    [offscreenView pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
}

- (void)transformNextStepInputView:(NSInteger)Index {

    switch (Index) {
        case 1: {
            [self transformInputViewWithNextStepAnimationOffScreen:self.inputView1 OnScreen:self.inputView2];
            break;
        }
        case 2: {
            [self transformInputViewWithNextStepAnimationOffScreen:self.inputView2 OnScreen:self.inputView3];
            break;
        }
        case 3: {
            [self transformInputViewWithNextStepAnimationOffScreen:self.inputView3 OnScreen:self.inputView4];
            break;
        }
        case 4: {
            [self transformInputViewWithNextStepAnimationOffScreen:self.inputView4 OnScreen:self.inputView5];
            break;
        }
    }
}

- (void)transformUpStepInputView:(NSInteger)Index {
    
    switch (Index) {
        case 2: {
            [self transformInputViewWithUpStepAnimationOffScreen:self.inputView2 OnScreen:self.inputView1];
            break;
        }
        case 3: {
            [self transformInputViewWithUpStepAnimationOffScreen:self.inputView3 OnScreen:self.inputView2];
            break;
        }
        case 4: {
            [self transformInputViewWithUpStepAnimationOffScreen:self.inputView4 OnScreen:self.inputView3];
            break;
        }
        case 5: {
            [self transformInputViewWithUpStepAnimationOffScreen:self.inputView5 OnScreen:self.inputView4];
            break;
        }
    }
}

- (void)hiddenStepButton {

    CGFloat toValue = CGRectGetMidX(self.view.bounds);
    
    POPBasicAnimation *upStepAnimation = [POPBasicAnimation easeInEaseOutAnimation];
    upStepAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
    upStepAnimation.duration = .3f;
    upStepAnimation.toValue = @(toValue);
    [self.upStepButton pop_addAnimation:upStepAnimation forKey:@"upStepAnimation"];
    POPBasicAnimation *upStepAlphaAnimation = [POPBasicAnimation easeOutAnimation];
    upStepAlphaAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    upStepAlphaAnimation.toValue = @(0);
    upStepAlphaAnimation.duration = .5f;
    [self.upStepButton pop_addAnimation:upStepAlphaAnimation forKey:@"upStepAlphaAnimation"];
    
    POPBasicAnimation *nextStepAnimation = [POPBasicAnimation easeInEaseOutAnimation];
    nextStepAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
    nextStepAnimation.toValue = @(toValue);
    nextStepAnimation.duration = .3f;
    [self.nextStepButton pop_addAnimation:nextStepAnimation forKey:@"nextStepAnimation"];
    POPBasicAnimation *nextStepAlphaAnimation = [POPBasicAnimation easeOutAnimation];
    nextStepAlphaAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    nextStepAlphaAnimation.toValue = @(0);
    nextStepAlphaAnimation.duration = .5f;
    nextStepAlphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self addFinishButton];
    };
    [self.nextStepButton pop_addAnimation:nextStepAlphaAnimation forKey:@"nextStepAlphaAnimation"];
}

- (void)addFinishButton {

    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    finishButton.frame = CGRectMake( self.upStepButton.center.x, self.upStepButton.center.y, 1, 1);
    finishButton.layer.cornerRadius = 7.f;
    finishButton.backgroundColor = [UIColor aci_colorWithHex:0xff0EA5F3];
    [self.view addSubview:finishButton];
    
    POPSpringAnimation *addFinshButtonAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewBounds];
    addFinshButtonAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 250, 30)];
    addFinshButtonAnimation.springBounciness = 10;
    addFinshButtonAnimation.springSpeed = 5;
    [finishButton pop_addAnimation:addFinshButtonAnimation forKey:@"addFinshButtonAnimation"];
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
