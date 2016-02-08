//
//  LoginViewController.m
//  Anteater
//
//  Created by Sam Madden on 1/22/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingsModel.h"
#import "AnteaterREST.h"
#import <UIKit/UIKit.h>

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated {
    _okButton.layer.cornerRadius = 5.0;
    _okButton.backgroundColor = [UIColor blueColor];
    _userName.delegate = self;
}


-(IBAction)hitOK:(id)sender {
    if ([[_userName text] length] >= 3) {
        [AnteaterREST registerUser:[_userName text] withDeviceId:[[[UIDevice currentDevice] identifierForVendor] UUIDString] andCallback:^(int resultCode, NSDictionary *result) {
            if (resultCode == HTTP_STATUS_OK) {
                [[SettingsModel instance] setUsername:[_userName text]];
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.delegate loginComplete];
            } else {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Request failed"
                                                                               message:@"Network request failed, please try again."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];

            }
        }];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid username"
                                                                       message:@"Please enter a username that is at least 3 characters."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


@end
