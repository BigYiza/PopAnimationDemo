//
//  ADJLoginViewController.m
//  POPAnimationDemo
//
//  Created by 张义 on 2017/4/26.
//  Copyright © 2017年 BearZ. All rights reserved.
//

#import "ADJLoginViewController.h"
#import "UIColor+ACIHex.h"
#import "POP.h"
#import "ADJUserRegisterViewController.h"

typedef NS_ENUM(NSInteger, ADJChangeType) {

    ADJChangeTypeUserNameSelected,
    ADJChangeTypePasswordSelected
};
static CGSize logoImageSize;

@interface ADJLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *userNameContentView;
@property (weak, nonatomic) IBOutlet UIView *passwordContentView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNamePlaceholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (nonatomic, assign) CGFloat offSetLength;
@property (nonatomic, assign) CGFloat keyboardHeight;


@end

@implementation ADJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyboard:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (textField == self.userNameTextField) {
        [self pop_setInputStateContentViewUI:ADJChangeTypeUserNameSelected];
    } else if (textField == self.passwordTextField) {
    
        [self pop_setInputStateContentViewUI:ADJChangeTypePasswordSelected];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.userNameTextField) {
        if (self.userNameTextField.text.length == 0) {
            [self pop_SetDefaultContentViewUI:ADJChangeTypeUserNameSelected];
        }
    } else if (textField == self.passwordTextField) {
        
        if (self.passwordTextField.text.length == 0) {
            [self pop_SetDefaultContentViewUI:ADJChangeTypePasswordSelected];
        }
    }
}

#pragma mark - handler event
- (IBAction)backgroundClicked:(id)sender {
    
    [self.view endEditing:YES];
}

- (IBAction)loginButtonClicked:(id)sender {
    
    [self.view endEditing:YES];

    [self hideLabel];
    self.loginButton.userInteractionEnabled = NO;
    
    
    // 新增自视图会移除自视图中的动画
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activityView.center = self.loginButton.center;
//    [self.mainContentView addSubview:activityView];
//    [self.mainContentView bringSubviewToFront:activityView];
    [self.activityView startAnimating];
    self.activityView.hidden = NO;
    [self.loginButton setTitle:@"" forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.activityView stopAnimating];
        self.activityView.hidden = YES;
        [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
        if ([self.passwordTextField.text isEqualToString:@"123456"]) {
            
            self.loginButton.userInteractionEnabled = YES;
        } else {
            
            [self loginFailedSharkButton];
            [self showLabel];
        }
    });
}

- (IBAction)goRegistAccount:(UIButton *)sender {
    
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    UINavigationController *registerViewControllerNav = [stroyBoard instantiateViewControllerWithIdentifier:@"registerViewControllerNav"];
    [self presentViewController:registerViewControllerNav animated:YES completion:nil];

}

#pragma mark- private method
- (void)configUI {

    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.userNameContentView.layer.borderWidth = .5f;
    self.userNameContentView.layer.borderColor = [UIColor aci_colorWithHex:0xffAAAAAA].CGColor;
    self.userNameContentView.layer.cornerRadius = 20.f;
    
    self.passwordContentView.layer.borderWidth = .5f;
    self.passwordContentView.layer.borderColor = [UIColor aci_colorWithHex:0xffAAAAAA].CGColor;
    self.passwordContentView.layer.cornerRadius = 20.f;
    
    self.loginButton.layer.cornerRadius = 5.f;
    
    logoImageSize = self.logoImage.frame.size;
    self.activityView.hidden = YES;
    [self configErrorLabel];
}

- (void)pop_SetDefaultContentViewUI:(ADJChangeType)changeType {

    switch (changeType) {
        case ADJChangeTypeUserNameSelected: {
        
            POPBasicAnimation *ani_1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
            ani_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            ani_1.toValue = (__bridge id)[UIColor aci_colorWithHex:0xffAAAAAA].CGColor;
            ani_1.duration = 0.1;
            [self.userNameContentView.layer pop_addAnimation:ani_1 forKey:@"ani_1"];
            
            POPBasicAnimation *ani_2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
            ani_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            ani_2.toValue = [UIColor aci_colorWithHex:0xffAAAAAA];
            ani_2.duration = 0.1;
            if (self.userNameTextField.text.length == 0) {
                ani_2.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                    POPSpringAnimation *ani_3 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                    ani_3.toValue = @(30);  // 相对于父试图的Y值偏移
                    ani_3.springBounciness = 10;
                    ani_3.springSpeed = 5;
                    [self.userNamePlaceholderLabel pop_addAnimation:ani_3 forKey:@"ani_3"];
                };
            }
            [self.userNamePlaceholderLabel pop_addAnimation:ani_2 forKey:@"ani_2"];
        }
        case ADJChangeTypePasswordSelected: {
        
            POPBasicAnimation *ani_1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
            ani_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            ani_1.toValue = (__bridge id)[UIColor aci_colorWithHex:0xffAAAAAA].CGColor;
            ani_1.duration = 0.1;
            [self.passwordContentView.layer pop_addAnimation:ani_1 forKey:@"ani_1"];
            
            POPBasicAnimation *ani_2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
            ani_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            ani_2.toValue = [UIColor aci_colorWithHex:0xffAAAAAA];
            ani_2.duration = 0.1;
            if (self.passwordTextField.text.length == 0) {
                ani_2.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                    POPSpringAnimation *ani_3 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                    ani_3.toValue = @(85);
                    ani_3.springBounciness = 10;
                    ani_3.springSpeed = 5;
                    [self.passwordPlaceholderLabel pop_addAnimation:ani_3 forKey:@"ani_3"];
                };
            }
            [self.passwordPlaceholderLabel pop_addAnimation:ani_2 forKey:@"ani_2"];
            
            break;
        }
        default:
            break;
    }
}

- (void)pop_setInputStateContentViewUI:(ADJChangeType)changeType {

//    [self reponseShowKeyboardUIChange];
    switch (changeType) {
        case ADJChangeTypeUserNameSelected: {
            
            POPBasicAnimation *ani_1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
            ani_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            ani_1.toValue = (__bridge id)[UIColor aci_colorWithHex:0xffB12524].CGColor;
            ani_1.duration = 0.1;
            [self.userNameContentView.layer pop_addAnimation:ani_1 forKey:@"ani_1"];
            
            POPBasicAnimation *ani_2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
            ani_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            ani_2.toValue = [UIColor aci_colorWithHex:0xffB12524];
            ani_2.duration = 0.1;
            ani_2.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                POPSpringAnimation *ani_3 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                ani_3.toValue = @(10);  // 相对于父试图的Y值偏移
                ani_3.springBounciness = 10;
                ani_3.springSpeed = 5;
                [self.userNamePlaceholderLabel pop_addAnimation:ani_3 forKey:@"ani_3"];
            };
            [self.userNamePlaceholderLabel pop_addAnimation:ani_2 forKey:@"ani_2"];
            
            break;
        }
        case ADJChangeTypePasswordSelected: {
            
            POPBasicAnimation *ani_1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
            ani_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            ani_1.toValue = (__bridge id)[UIColor aci_colorWithHex:0xffB12524].CGColor;
            ani_1.duration = 0.1;
            [self.passwordContentView.layer pop_addAnimation:ani_1 forKey:@"ani_1"];
            
            POPBasicAnimation *ani_2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
            ani_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            ani_2.toValue = [UIColor aci_colorWithHex:0xffB12524];
            ani_2.duration = 0.1;
            ani_2.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                POPSpringAnimation *ani_3 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                ani_3.toValue = @(65);
                ani_3.springBounciness = 10;
                ani_3.springSpeed = 5;
                [self.passwordPlaceholderLabel pop_addAnimation:ani_3 forKey:@"ani_3"];
            };
            [self.passwordPlaceholderLabel pop_addAnimation:ani_2 forKey:@"ani_2"];
            
            break;
        }
        default:
            break;
    }
}

- (void)reponseShowKeyboardUIChange {
    
    float contentViewHeight = self.mainContentView.frame.size.height;
    float contentViewY = self.mainContentView.frame.origin.y;
    
    POPBasicAnimation *ani_1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    ani_1.toValue = @(contentViewY + contentViewHeight/2 - self.offSetLength);     //toValue的值确定了View变化后center的Y值坐标
    ani_1.duration = 0.3;
    ani_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.mainContentView.layer pop_addAnimation:ani_1 forKey:@"ani_1"];
    
    POPBasicAnimation *ani_2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    ani_2.toValue = @(self.versionLabel.frame.origin.y + self.versionLabel.frame.size.height/2 - self.offSetLength);
    ani_2.duration = 0.3;
    ani_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.versionLabel.layer pop_addAnimation:ani_2 forKey:@"ani_2"];
    
//    POPSpringAnimation *ani_3 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewBounds];
//    ani_3.toValue = [NSValue valueWithCGRect:CGRectMake(self.logoImage.frame.origin.x, self.logoImage.frame.origin.y - self.offSetLength, logoImageSize.width / 2, logoImageSize.height / 2)];
//    ani_3.springBounciness = 10;
//    ani_3.springSpeed = 5;
//    [self.logoImage pop_addAnimation:ani_3 forKey:@"ani_3"];
    POPBasicAnimation *ani_3 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBounds];
    ani_3.toValue = [NSValue valueWithCGRect:CGRectMake(self.logoImage.frame.origin.x, self.logoImage.frame.origin.y - self.offSetLength, logoImageSize.width / 2, logoImageSize.height / 2)];
    ani_3.duration = 0.3;
    ani_2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.logoImage pop_addAnimation:ani_3 forKey:@"ani_3"];
}

- (void)reponseHiddenKeyboardUIChange {

    [self.mainContentView pop_removeAllAnimations];
    [self.versionLabel pop_removeAllAnimations];
    [self.logoImage pop_removeAllAnimations];
}

- (void)showKeyboard:(NSNotification *)notification {
    // 计算键盘的高度
    float keyBoardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    if (self.keyboardHeight == keyBoardHeight) {
        self.keyboardHeight = keyBoardHeight;
    }
    [self reponseShowKeyboardUIChange];
}

- (void)hiddenKeyboard:(NSNotification *)notification {

    [self reponseHiddenKeyboardUIChange];
}

- (void)loginFailedSharkButton {

    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.beginTime = CACurrentMediaTime() + 0.1;
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.loginButton.userInteractionEnabled = YES;
    }];
    [self.loginButton.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)configErrorLabel {

    self.errorLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16];
    self.errorLabel.textColor = [UIColor colorWithRed:177/255.0 green:37/255.0 blue:36/255.0 alpha:1.0];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.text = @"Wrong Password. Password is 123456";
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    
    self.errorLabel.layer.opacity = 0.0;
    
}

- (void)showLabel {
    
    self.errorLabel.layer.opacity = 1.0;
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
    
    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.loginButton.layer.position.y + self.loginButton.intrinsicContentSize.height);
    layerPositionAnimation.springBounciness = 12;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}

- (void)hideLabel {
    
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.loginButton.layer.position.y);
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}

- (CGFloat)keyboardHeight {

    if (!_keyboardHeight) {
        _keyboardHeight = 220.f;
    }
    return _keyboardHeight;
}

- (CGFloat)offSetLength {

    float contentViewHeight = self.mainContentView.frame.size.height;
    float contentViewY = self.mainContentView.frame.origin.y;
    float offsetLength = self.keyboardHeight - (self.view.frame.size.height - (contentViewY + contentViewHeight));
    
    _offSetLength = offsetLength;
    return _offSetLength;
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
