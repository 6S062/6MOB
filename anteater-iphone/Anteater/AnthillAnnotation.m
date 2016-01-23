//
//  AnthillAnnotation.m
//  Anteater
//
//  Created by Sam Madden on 1/22/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "AnthillAnnotation.h"

@implementation AnthillAnnotation {
    NSDictionary *_data;
}

-(id)initWithAnthillData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    float lat = [[_data objectForKey:@"lat"] floatValue];
    float lon = [[_data objectForKey:@"lon"] floatValue];
    return CLLocationCoordinate2DMake(lat, lon);
}

-(NSString *)title {
    return [_data objectForKey:@"id"];
}

@end
