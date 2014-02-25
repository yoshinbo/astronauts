//
//  PhysicsNode.h
//  astronauts
//
//  Created by Yoshikazu Oda on 2014/02/24.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"

@interface PhysicsNode : CCNode <CCPhysicsCollisionDelegate>

- (PhysicsNode *)initWithContentSize:(CGSize)contentSize;

@end
