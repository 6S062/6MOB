//
//  LoginViewController.h
//  Anteater
//
//  Created by Sam Madden on 1/22/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

-(void)loginComplete;

@end

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property id<LoginViewDelegate> delegate;

@property IBOutlet UIButton *okButton;
@property IBOutlet UITextField *userName;

-(IBAction)hitOK:(id)sender;

@end
