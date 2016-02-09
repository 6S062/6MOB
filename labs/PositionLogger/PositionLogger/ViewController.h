//
//  ViewController.h
//  PositionLogger
//
//  Created by Sam Madden on 2/3/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
    Cellular = 0,
    WiFi = 1,
    GPS = 2
} LocationAccuracy;

@interface ViewController : UIViewController<MFMailComposeViewControllerDelegate,CLLocationManagerDelegate>

@property IBOutlet UISegmentedControl *accuracyControl;
@property IBOutlet UIButton *startStopButton;
@property IBOutlet UIActivityIndicatorView *recordingIndicator;

-(IBAction)hitRecordStopButton:(UIButton *)b;
-(IBAction)hitClearButton:(UIButton *)b;
-(IBAction)emailLogFile:(UIButton *)b;


@end

