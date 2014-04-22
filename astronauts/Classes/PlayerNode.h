//
//  PlayerNode.h
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/23.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"

@interface PlayerNode : CCSprite

@property CGFloat velocity_y;

- (PlayerNode *)initWithPosition:(CGPoint)position;
- (void)move:(CCTime)delta;
- (void)jump;

@end
