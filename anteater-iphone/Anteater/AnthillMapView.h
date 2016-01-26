//
//  AnthillMapView.h
//  Anteater
//
//  Created by Sam Madden on 1/22/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "CompassView.h"

@interface AnthillMapView : MKMapView<MKMapViewDelegate>
@property IBOutlet CompassView *cv;
@end
