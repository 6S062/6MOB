//
//  BLESensorReading.m
//  Anteater
//
//  Created by Sam Madden on 1/13/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "BLESensorReading.h"

@implementation BLESensorReading

-(id)initWithReadingValue:(float)value andType:(SensorReadingType)type atTime:(NSDate *)time {
    self = [super init];
    if (self) {
        _value = value;
        _type = type;
        _time = time;
    }
    return self;
}


-(NSString *)formattedValue {
    NSString *label = @"";
    switch (_type) {
        case kTemperatureReading:
            label = [NSString stringWithFormat:@"%.1f °F",_value];
            break;
        case kHumidityReading:
            label = [NSString stringWithFormat:@"%.1f %%",_value];
            break;
    }
    return label;
}

@end
