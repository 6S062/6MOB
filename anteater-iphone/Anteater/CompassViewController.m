//
//  CompassViewController.m
//  Anteater
//
//  Created by Sam Madden on 1/29/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "CompassViewController.h"
#import "AnteaterREST.h"

@interface CompassViewController ()

@end

@implementation CompassViewController {
    NSArray *_anthills;
    CLLocationManager *_mgr;
    UIImage *_image;
    BOOL gotLoc;
    CLLocationCoordinate2D _lastLoc, _userLoc, _targetLoc;
    CGFloat _curHeading, _lastHeading, _scale, _lastMagHeading;
}

- (void)viewDidLoad {
    _mgr = [[CLLocationManager alloc] init];
    _mgr.delegate = self;
    _mgr.desiredAccuracy = kCLLocationAccuracyBest;
    _mgr.distanceFilter = 0;
    _mgr.headingOrientation = CLDeviceOrientationPortrait;
    [_mgr startUpdatingHeading];
    [_mgr startUpdatingLocation];
    _anthills = @[];
    _picker.dataSource = self;
    _picker.delegate = self;
    [AnteaterREST getListOfAnthills:^(NSDictionary *hills) {
        if (hills)
            _anthills = [hills objectForKey:@"anthills"];
        [_picker reloadAllComponents];
        [self updateCompassScaleAndHeading];
    }];
    
    self.distanceLabel.text = @"";
    self.headingLabel.text = @"";
    [self updateCompassScaleAndHeading];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (double)computeHeadingFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    double fLat = degToRad(fromLoc.latitude);
    double fLng = degToRad(fromLoc.longitude);
    double tLat = degToRad(toLoc.latitude);
    double tLng = degToRad(toLoc.longitude);
    
    double degrees = radToDeg(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
   // if (degrees < 0) degrees = degrees + 360;
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
    //if (head < 0) head = head + 360;
    
    //NSLog(@"Got heading = %f (estimated direction = %f)", _lastMagHeading,  head);
    CGAffineTransform t = CGAffineTransformMakeScale(_scale, _scale);
    //CGAffineTransformMakeTranslation(self.frame.size.width/2, self.frame.size.height/2);

    _lastHeading = head; //head * .5 + _lastHeading * .5; //smooth
    
    t = CGAffineTransformRotate(t, degToRad(_lastHeading));
    
    _needle.transform = t;
    self.headingLabel.text = [NSString stringWithFormat:@"%.1f°",head];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    _lastMagHeading = [newHeading trueHeading];
    NSLog(@"%f",_lastMagHeading);
    _lastMagHeading -= 90;
    [self updateCompassScaleAndHeading];
    
}

-(void)updateCompassScaleAndHeading {
    if (!_anthills || ![_anthills count])
        return;
    
    CLLocationCoordinate2D hill = [self curSelectedLocation];
    _targetLoc = hill;
    _userLoc = _lastLoc;

    [self rotateArrow];

}


-(void)locationManager:(CLLocationManager*)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    CLLocationCoordinate2D me = [[locations objectAtIndex:0] coordinate];
    _lastLoc = me;
    gotLoc = TRUE;
    [self updateCompassScaleAndHeading];

}


#pragma  mark -- Picker View

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_anthills count];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    return [[_anthills objectAtIndex:row] objectForKey:@"id"];
}

-(CLLocationCoordinate2D) curSelectedLocation {
    
    NSDictionary *d = [_anthills objectAtIndex:[_picker selectedRowInComponent:0]];
    CLLocationCoordinate2D hill = CLLocationCoordinate2DMake([[d objectForKey:@"lat"] floatValue] , [[d objectForKey:@"lon"] floatValue]);
    return hill;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED
{
    [self updateCompassScaleAndHeading];

}


@end
