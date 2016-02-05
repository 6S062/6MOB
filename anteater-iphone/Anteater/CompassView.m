//
//  CompassView.m
//  Anteater
//
//  Created by Sam Madden on 1/26/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "CompassView.h"
#import "AnteaterREST.h"




@implementation CompassView {
    CGFloat _curHeading, _lastHeading, _scale;
    UIImage *_image;
}


-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.anchorPoint = CGPointMake(.5, .5);
        _scale = 1.0;
        _image = self.image;
        //_rotation = 97;
        //_scale = .4;
        self.distanceLabel.text = @"";
        self.headingLabel.text = @"";
        [self rotateArrow];

        //self.layer.borderWidth = 1.0;
        //self.layer.borderColor = [[UIColor blackColor] CGColor];
        
        

    }
    return self;
}


- (double)computeHeadingFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    double fLat = degToRad(fromLoc.latitude);
    double fLng = degToRad(fromLoc.longitude);
    double tLat = degToRad(toLoc.latitude);
    double tLng = degToRad(toLoc.longitude);
    
    double degrees = radToDeg(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    return degrees;
    
}


-(void)rotateArrow {
        
    _curHeading = [self computeHeadingFromCoordinate:_userLoc toCoordinate:_targetLoc];
    
    CLLocationDistance distanceKm = [[[CLLocation alloc] initWithLatitude:_userLoc.latitude longitude:_userLoc.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:_targetLoc.latitude longitude:_targetLoc.longitude]] / 1000.0;
    if (distanceKm < 2.0) {
        //_scale = 1.0 - (pow(1000,(2.0 - distanceKm)/2.0) / 1000.0); //shrink arrow as we get closer
        _scale = 1.0;
        NSLog(@"Distance = %f, _scale = %f",distanceKm,_scale);
        
    } else {
        _scale = 1.0;
    }

    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f km",distanceKm];

    double head =(_curHeading - _lastMagHeading);
    if (head < 0) head = head + 360;
    
    //NSLog(@"Got heading = %f (estimated direction = %f)", _lastMagHeading,  head);
    CGAffineTransform t = CGAffineTransformMakeScale(_scale, _scale);
    //CGAffineTransformMakeTranslation(self.frame.size.width/2, self.frame.size.height/2);
    
    _lastHeading = head; //head * .5 + _lastHeading * .5; //smooth

    t = CGAffineTransformRotate(t, degToRad(_lastHeading));
    
    self.transform = t;
    self.headingLabel.text = [NSString stringWithFormat:@"%.1f°",head];
    //if (gotLoc)
    //    self.image = [_image imageRotatedByDegrees:_curHeading - [newHeading trueHeading]];
    

}





@end
