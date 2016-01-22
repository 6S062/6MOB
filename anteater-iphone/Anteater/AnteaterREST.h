//
//  AnteaterREST.h
//  Anteater
//
//  Created by Sam Madden on 1/21/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnteaterREST : NSObject

+(void) getListOfAnthills:(void (^)(NSDictionary *))callback;

@end
