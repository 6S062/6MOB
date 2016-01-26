//
//  BLESensorReading.m
//  Anteater
//
//  Created by Sam Madden on 1/13/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "BLESensorReading.h"
#import <UIKit/UIKit.h>

@implementation BLESensorReading

-(id)initWithReadingValue:(float)value andType:(SensorReadingType)type atTime:(NSDate *)time andSensorId:(NSString *)sensorId {
    self = [super init];
    if (self) {
        _value = value;
        _type = type;
        _time = time;
        _sensorId = sensorId;
    }
    return self;
}

-(UIImage *) readingIcon {
    switch (_type) {
        case kTemperatureReading:
            return [UIImage imageNamed:@"thermo"];
            break;
        case kHumidityReading:
            return [UIImage imageNamed:@"humidity"];
            break;
    }
    return NULL;
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

-(NSString *)toJson {
    NSDictionary *d = @{@"value":@(_value),@"type":@(_type),@"timestamp":@([_time timeIntervalSince1970]),@"userid":[[[UIDevice currentDevice] identifierForVendor] UUIDString],@"sensorid":_sensorId};
    NSData *data = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
