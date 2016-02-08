//
//  CompassView.m
//  Anteater
//
//  Created by Sam Madden on 1/26/16.
//  Copyright © 2016 Sam Madden. All rights reserved.
//

#import "CompassView.h"
#import "AnteaterREST.h"




@implementation CompassView

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.anchorPoint = CGPointMake(.5, .5);

    }
    return self;
}






@end
