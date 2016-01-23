//
//  SettingsModel.h
//  Anteater
//
//  Created by Sam Madden on 1/22/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsModel : NSObject

@property NSString *username;
+(SettingsModel *)instance;

@end
