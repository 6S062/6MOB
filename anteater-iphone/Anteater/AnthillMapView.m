//
//  AnthillMapView.m
//  Anteater
//
//  Created by Sam Madden on 1/22/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "AnthillMapView.h"
#import "AnteaterREST.h"
#import "AnthillAnnotation.h"

@implementation AnthillMapView
{
    //NSArray<NSDictionary *> *_hills;
    NSMutableDictionary<NSString*, id<MKAnnotation>> *_annots;
    NSMutableDictionary<NSString*, NSDictionary*> *_hills, *_oldHills;
}

-(void) doInit {
    [self setZoomEnabled:YES];
    self.delegate = self;
    self.showsUserLocation = YES;
    
    _annots = [[NSMutableDictionary alloc] init];
    _hills = [[NSMutableDictionary alloc] init];

    [AnteaterREST getListOfAnthills:^(NSDictionary *result){
        if (result) {
            NSArray *hills = [result objectForKey:@"anthills"];
            _oldHills = _hills;
            _hills = [[NSMutableDictionary alloc] init];

            for (NSDictionary *h in hills) {
                [_hills setObject:h forKey:[h objectForKey:@"id"]];
            }
            [self updateMapView];
            if ([[_oldHills allKeys] count] != [[_hills allKeys] count]) {
                [self resizeMap];
            }
        }
        
    }];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateMapView) userInfo:nil repeats:YES];
}

-(void)resizeMap {
    float maxLat=-500,maxLon=-500,minLat=500,minLon=500;
    
    for (NSDictionary *hill in [_hills allValues]) {
        float lat = [[hill objectForKey:@"lat"] floatValue];
        float lon = [[hill objectForKey:@"lon"] floatValue];
        
        if (lat > maxLat) {
            maxLat =lat;
        }
        if (lat < minLat) {
            minLat = lat;
        }
        if (lon > maxLon) {
            maxLon = lon;
        }
        if (lon < minLon) {
            minLon = lon;
        }
    }
    if (maxLat != -500) { // at least one point
        maxLat += (maxLat - minLat) * .02; minLat -= (maxLat - minLat) * .02;
        maxLon += (maxLon - minLon) * .02; minLon -= (maxLon - minLon) * .02;
        
        MKCoordinateRegion region = self.region;
        region.center = CLLocationCoordinate2DMake(minLat + (maxLat-minLat)/2, minLon + (maxLon-minLon)/2);
        float height = maxLat - minLat;
        float width = maxLon - minLon;
        
        if (height < .01) height = .01;
        if (width < .01) width = .01;
        
        region.span.latitudeDelta = height;
        region.span.longitudeDelta = width;
        
        [self setRegion:region animated:YES];
    }

}


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];

    if (self) {
        [self doInit];
    }
    return self;
}

-(void) updateMapView {
    NSMutableArray *toRemove = [[_annots allKeys] copy];
    for (NSDictionary *h in [_hills allValues]) {
        NSString *hid =[h objectForKey:@"id"];
        NSDictionary *current = [_oldHills objectForKey:hid];
        if ([current isEqualToDictionary:h]) { //didn't change
            [toRemove removeObject:hid];
        } else {
            AnthillAnnotation *a = [[AnthillAnnotation alloc] initWithAnthillData:h];
            [self addAnnotation:a];
            [_annots setObject:a forKey:hid];
        }
    }
    AnthillAnnotation *dummy = [[AnthillAnnotation alloc] initWithAnthillData:NULL];

    NSArray *annotsToRemove = [_annots objectsForKeys:toRemove notFoundMarker:dummy];
    [_annots removeObjectsForKeys:toRemove];
    [self removeAnnotations:annotsToRemove];

}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[AnthillAnnotation class]]) {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        pin.pinTintColor = [UIColor yellowColor];
        pin.canShowCallout = YES;
        return pin;
    }
    return nil;
}


@end
