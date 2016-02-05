//
//  CompassView.h
//  Anteater
//
//  Created by Sam Madden on 1/26/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

//displays a needle pointing towards a destination, and (optionally) updates two labels (the heading and distance)
//based on the user's location, a target location, and the current orientation of the phone
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define degToRad(x) (M_PI * (x) / 180.0)
#define radToDeg(x) ((x) * 180.0 / M_PI)

@interface CompassView : UIImageView
@property double lastMagHeading;
@property CLLocationCoordinate2D userLoc, targetLoc;
@property IBOutlet UILabel *headingLabel, *distanceLabel;

-(void)rotateArrow;

@end
