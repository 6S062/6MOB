//
//  SettingsModel.m
//  Anteater
//
//  Created by Sam Madden on 1/22/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "SettingsModel.h"

static SettingsModel *instance = NULL;

#define kUSERNAME_KEY @"username"
#define kLASTCONNECTED_KEY @"lastConnected"

@implementation SettingsModel

+(SettingsModel *)instance {
    if (!instance) {
        instance = [[SettingsModel alloc] init];
    }
    return instance;
}

-(NSString *)username {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUSERNAME_KEY];
}

-(void)setUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kUSERNAME_KEY];
}

-(NSDictionary *) lastConnectedTimes{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLASTCONNECTED_KEY];
}

-(void) setLastConnectedTimes:(NSDictionary *)times{
    [[NSUserDefaults standardUserDefaults] setObject:times forKey:kLASTCONNECTED_KEY];
}


@end
