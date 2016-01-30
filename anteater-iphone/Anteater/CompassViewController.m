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
    CLLocationCoordinate2D _lastLoc;
}

- (void)viewDidLoad {
    _mgr = [[CLLocationManager alloc] init];
    _mgr.delegate = self;
    _mgr.desiredAccuracy = kCLLocationAccuracyBest;
    _mgr.distanceFilter = 0;
    [_mgr startUpdatingHeading];
    [_mgr startUpdatingLocation];
    _anthills = @[];
    _picker.dataSource = self;
    _picker.delegate = self;
    [AnteaterREST getListOfAnthills:^(NSDictionary *hills) {
        if (hills)
            _anthills = [hills objectForKey:@"anthills"];
        [_picker reloadAllComponents];
    }];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    _compass.lastMagHeading = [newHeading trueHeading];
    [_compass rotateArrow];
    
}

-(void)updateCompassScaleAndHeading {
    if (!_anthills || ![_anthills count])
        return;
    
    CLLocationCoordinate2D hill = [self curSelectedLocation];
    _compass.targetLoc = hill;
    _compass.userLoc = _lastLoc;

    //NSLog(@"estimated heading from loc = %f ", _compass.curHeading);   // scale = 100 - distance
    //self.image = [_image imageRotatedByDegrees:_curHeading];
    [_compass rotateArrow];

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

// returns the # of rows in each component..
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

/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
