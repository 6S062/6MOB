//
//  CompassView.m
//  Anteater
//
//  Created by Sam Madden on 1/26/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "CompassView.h"
#import "AnteaterREST.h"


#define degToRad(x) (M_PI * (x) / 180.0)
#define radToDeg(x) ((x) * 180.0 / M_PI)


@implementation CompassView {
    double _curHeading;
    NSArray *_anthills;
    CLLocationManager *_mgr;
    UIImage *_image;
    BOOL gotLoc;
    double _lastHeading, _lastMagHeading;
    double _scale;
    CGFloat _rotation;
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

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _mgr = [[CLLocationManager alloc] init];
        _mgr.delegate = self;
        _mgr.desiredAccuracy = kCLLocationAccuracyBest;
        _mgr.distanceFilter = 0;
        
        [_mgr startUpdatingHeading];
        [_mgr startUpdatingLocation];
        _anthills = @[];
        [AnteaterREST getListOfAnthills:^(NSDictionary *hills) {
            if (hills)
                _anthills = [hills objectForKey:@"anthils"];

        }];
        self.backgroundColor = [UIColor clearColor];
        self.layer.anchorPoint = CGPointMake(.5, .5);
        _scale = 1.0;
        _image = self.image;
        //self.layer.borderWidth = 1.0;
        //self.layer.borderColor = [[UIColor blackColor] CGColor];

    }
    return self;

}

-(void)rotateArrow {
    double head =(_curHeading - _lastMagHeading) + _rotation;
    NSLog(@"Got heading = %f (estimated direction = %f)", _lastMagHeading,  head);
    CGAffineTransform t = CGAffineTransformMakeScale(_scale, _scale);
    //CGAffineTransformMakeTranslation(self.frame.size.width/2, self.frame.size.height/2);
    
    _lastHeading = head; //head * .5 + _lastHeading * .5; //smooth
    t = CGAffineTransformRotate(t, degToRad(_lastHeading));
    
    if (gotLoc)
        self.transform = t;
    //if (gotLoc)
    //    self.image = [_image imageRotatedByDegrees:_curHeading - [newHeading trueHeading]];
    

}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    _lastMagHeading = [newHeading trueHeading];
    [self rotateArrow];

}

-(void)locationManager:(CLLocationManager*)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    CLLocationCoordinate2D hill = CLLocationCoordinate2DMake(42.3598, -71.0921);
    CLLocationCoordinate2D me = [[locations objectAtIndex:0] coordinate];
    _curHeading = [self computeHeadingFromCoordinate:me toCoordinate:hill];
    gotLoc = TRUE;
    
    CLLocationDistance distanceKm = [[locations objectAtIndex:0] distanceFromLocation:[[CLLocation alloc] initWithLatitude:hill.latitude longitude:hill.longitude]] / 1000.0;
    if (distanceKm < 2.0) {
        _scale = 1.0 - (pow(1000,(2.0 - distanceKm)/2.0) / 1000.0); //shrink arrow as we get closer
        NSLog(@"Distance = %f, _scale = %f",distanceKm,_scale);
        
    } else {
        _scale = 1.0;
    }
    NSLog(@"estimated heading from loc = %f ", _curHeading);   // scale = 100 - distance
    //self.image = [_image imageRotatedByDegrees:_curHeading];
}

-(CGFloat)rotationOffset {
    return _rotation;
}

-(void)setRotationOffset:(CGFloat)rotation {
    _rotation = rotation + 180;
    [self rotateArrow];
    
}



@end
