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
    NSString *idStr=[_data objectForKey:@"id"];
    NSString *description = [_data objectForKey:@"description"];
    if (!description || (NSNull *)description == [NSNull null])
        return idStr;
    else return  [NSString stringWithFormat:@"%@ - %@",idStr,description];

}

-(int)getPointsForVisitingAnthillWithDate:(NSDate *)d {
    float diff = [d timeIntervalSinceNow] * -1;
    if (diff > 360 * 30)
        return 5;
    else if (diff > 360 * 10)
        return 2;
    else if (diff > 360 * 5)
        return 1;
    else return 0;
        
}

-(NSString *)subtitle {
    NSString *dateString;
    NSNumber *date = [_data objectForKey:@"last_heard"];
    if (!date || (NSNull *)date == [NSNull null])
        return @"No connections (5 points)";
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[date floatValue]];
    dateString = [NSString stringWithFormat:@"Last heard:%@. ",[NSDateFormatter localizedStringFromDate:d dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
    
    return  [NSString stringWithFormat:@"%@ (%d points)",dateString, [self getPointsForVisitingAnthillWithDate:d]];
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
