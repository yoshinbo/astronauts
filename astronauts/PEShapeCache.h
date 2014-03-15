//
//  ShapeCache.h 
//
//  Created by James Meyer on 2/10/14.
//
//  Copyright 2014 James Meyer. All rights reserved.
//


/* This class is used to load physics shapes from a plist created by the
 Physics Editor (PE) software.  It should be used with a custom exporter set up
 specifically for CCPhysics.
 
 Limitations:
 --collisionCategories and collision masks are not implemented and must be added 
    manually if you are using them.
 --shape attributes (mass, friction, elasticity, etc.) are implemented PER
    FIXTURE, not per BODY.  Body mass will be the sum of all fixtures when
    all is loaded.  The ONLY CCPhysics attributes implemented on the body
    are allowsRotation and affectedByGravity.  Everything else goes THROUGH
    the shapes.
 --I have no cause to use multiple fixtures (shapes) per body yet, so I dont 
    know how that implementation works... if at all.
*/


#import "cocos2d.h"

@interface PEShapeCache : NSObject

// ShapeCache is a singleton, and this will return that single instance
+(PEShapeCache*)sharedShapeCache;

// reads the plist created with PE and creates a dictionary of body definitions
// with shape definitions in tow
-(BOOL)addPhysicsShapesWithFile:(NSString*)plist;

// Returns a CCPhysicsBody with accompanying shapes as well as other physics
// attributes
-(CCPhysicsBody*)bodyWithName:(NSString*)name;

// Returns the anchor point for use with a CCSprite
-(CGPoint)anchorPointForShape:(NSString*)shape;

@end
