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
        CCLabelBMFont* label1 = [[CCLabelBMFont alloc] initWithString:@"Bouncy"
                                                             fntFile:@"font.fnt"];
        label1.anchorPoint = ccp(0.5f, 0.5f);
        label1.position = ccp(self.contentSize.width/2,
                             self.contentSize.height/4*3);
        CCLabelBMFont* label2 = [[CCLabelBMFont alloc] initWithString:@"Astronauts"
                                                             fntFile:@"font.fnt"];
        label2.anchorPoint = ccp(0.5f, 0.5f);
        label2.position = ccp(self.contentSize.width/2,
                             self.contentSize.height/4*3-45);
        [self addChild:label1];
        [self addChild:label2];
        
        
    }

    return self;
}



@end
