//
//  IntroLayer.m
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/03/08.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "IntroLayer.h"

@implementation IntroLayer

- (IntroLayer *)initWithContentSize:(CGSize)contentSize
{
    self = [super init];

    if (self) {

        self.contentSize = contentSize;

        // Label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Touch to Start!"
                                               fontName:@"Marker Felt"
                                               fontSize:30];
        label.color = [CCColor whiteColor];
        label.position = ccp(self.contentSize.width/2,
                             self.contentSize.height/4*3);
        [self addChild:label];
    }

    return self;
}



@end
