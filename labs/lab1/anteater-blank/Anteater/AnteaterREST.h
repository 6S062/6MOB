//
//  AnteaterREST.h
//  Anteater
//
//  Created by Sam Madden on 1/21/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESensorReading.h"

#define HTTP_STATUS_OK 200
#define HTTP_STATUS_DUPLICATE 409

@interface AnteaterREST : NSObject

+(void) getListOfAnthills:(void (^)(NSDictionary *))callback;
+(void) postListOfSensorReadings:(NSArray<BLESensorReading *> *)readings andCallCallback:(void (^)(int resultCode, NSDictionary *))callback;
+(void) registerUser:(NSString *)userid withDeviceId:(NSString *)deviceid andCallback:(void (^)(int resultCode, NSDictionary *)) callback;
+(void) getLeaderboard:(void (^)(NSDictionary *))callback;

@end
