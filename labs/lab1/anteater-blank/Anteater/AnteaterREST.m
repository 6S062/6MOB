
//
//  AnteaterREST.m
//  Anteater
//
//  Created by Sam Madden on 1/21/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "AnteaterREST.h"

@implementation AnteaterREST

#define TIMEOUT 5

#define ANTHILLS_URL @"http://carteldb.csail.mit.edu/rest/get_anthills"

+(void) getListOfAnthills:(void (^)(NSDictionary *))callback {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:ANTHILLS_URL]];
    [request setTimeoutInterval:TIMEOUT];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:0
                                                                                          error:nil];
                                   NSLog(@"Async JSON: %@", json);
                                   callback(json);
                               }
                           }];

}


#define LEADERBOARD_URL @"http://carteldb.csail.mit.edu/rest/leaderboard"

+(void) getLeaderboard:(void (^)(NSDictionary *))callback {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://carteldb.csail.mit.edu/rest/leaderboard"]];
    [request setTimeoutInterval:TIMEOUT];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:0
                                                                                          error:nil];
                                   NSLog(@"Async JSON: %@", json);
                                   callback(json);
                               }
                           }];
    
}

#define SENSOR_READINGS_URL @"http://carteldb.csail.mit.edu/rest/post_data"

/* Readings should be an array of BLESensorReadings
 */
+(void) postListOfSensorReadings:(NSArray<BLESensorReading *> *)readings andCallCallback:(void (^)(int resultCode, NSDictionary *))callback {

    NSMutableString *post = [[NSMutableString alloc] initWithString:@"{\"readings\":[\n"];
    BOOL first = TRUE;
    for (BLESensorReading *r in readings) {
        [post appendString:[r toJson]];
        if (!first) {
            [post appendString:@",\n"];
        }
        first = FALSE;
    }
    [post appendString:@"\n]}"];
    [AnteaterREST doPostOfJson:post toUrl:@"http://carteldb.csail.mit.edu/rest/post_data" withCallback:callback];

}

+(void) registerUser:(NSString *)userid withDeviceId:(NSString *)did andCallback:(void (^)(int resultCode, NSDictionary *)) callback
{
    
    NSMutableString *post = [[NSMutableString alloc] initWithString:@"{\"user_info\":{\n"];
    [post appendString:[NSString stringWithFormat:@"\"name\":\"%@\"",userid]];
    [post appendString:[NSString stringWithFormat:@",\"deviceid\":\"%@\"}}",did]];
    
    [AnteaterREST doPostOfJson:post toUrl:@"http://carteldb.csail.mit.edu/rest/register_user" withCallback:callback];
    
}

+(void)doPostOfJson:(NSString *)json toUrl:(NSString *)urls withCallback:(void (^)(int resultCode, NSDictionary *)) callback{
    NSData *postData = [json dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *url =[NSURL URLWithString:urls];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:TIMEOUT];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response = nil;
        NSError *err;
        
        
        NSData *result = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:&response
                                                           error:&err];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = (int)[httpResponse statusCode];
        
        if ((statusCode == HTTP_STATUS_OK || statusCode == HTTP_STATUS_DUPLICATE) && result) {
            NSDictionary *resultDict;
            resultDict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&err];
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(statusCode,resultDict);
                });
            }
        } else {
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    callback(statusCode,NULL);
                });
            }
        }
    });

}



@end
