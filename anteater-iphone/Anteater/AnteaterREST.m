//
//  AnteaterREST.m
//  Anteater
//
//  Created by Sam Madden on 1/21/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "AnteaterREST.h"

@implementation AnteaterREST


#define ANTHILLS_URL @"http://carteldb.csail.mit.edu/cgi-bin/get_anthills"

+(void) getListOfAnthills:(void (^)(NSDictionary *))callback {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:ANTHILLS_URL]];
    
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

@end
