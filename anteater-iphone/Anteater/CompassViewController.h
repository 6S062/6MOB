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

@interface CompassViewController : UIViewController<CLLocationManagerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property IBOutlet CompassView *compass;
@property IBOutlet UIPickerView *picker;
@end
