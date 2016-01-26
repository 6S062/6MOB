//
//  CompassView.h
//  Anteater
//
//  Created by Sam Madden on 1/26/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CompassView : UIImageView<CLLocationManagerDelegate>
@property CGFloat rotationOffset;
@end
