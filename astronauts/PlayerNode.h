//
//  PlayerNode.h
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/23.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"

@interface PlayerNode : CCNode

@property CCSprite *playerSprite;
@property CGPoint point;
@property CGFloat velocity_y;
@property BOOL isUp;

- (PlayerNode *)initWithPosition:(CGPoint)position;

@end
