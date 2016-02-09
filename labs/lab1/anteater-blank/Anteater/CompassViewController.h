//
//  CompassViewController.h
//  Anteater
//
//  Created by Sam Madden on 1/29/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompassView.h"
#import <CoreLocation/CoreLocation.h>

#define degToRad(x) (M_PI * (x) / 180.0)
#define radToDeg(x) ((x) * 180.0 / M_PI)

@interface CompassViewController : UIViewController<CLLocationManagerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property IBOutlet CompassView *needle;
@property IBOutlet UIPickerView *picker;
@property IBOutlet UILabel *headingLabel, *distanceLabel;

@end
