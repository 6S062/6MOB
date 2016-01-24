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

-(NSString *)subtitle {
    NSNumber *date = [_data objectForKey:@"last_heard"];
    if (!date || (NSNull *)date == [NSNull null])
        return @"No connections.";
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[date floatValue]];
    return [NSString stringWithFormat:@"Last heard:%@",[NSDateFormatter localizedStringFromDate:d dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
}


-(UIColor *)colorForAnthill {
    NSNumber *date = [_data objectForKey:@"last_heard"];
    if (!date || (NSNull *)date == [NSNull null])
        return [UIColor redColor];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[date floatValue]];
    if ([d timeIntervalSinceNow] * -1 > 30 * 60) { //30 minutes
        return [UIColor yellowColor];
    } else {
        return [UIColor greenColor];
    }
}

@end
