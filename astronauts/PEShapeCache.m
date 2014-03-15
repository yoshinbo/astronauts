//
//  PEShapeCache.m
//
//  Created by James Meyer on 2/10/14.
//
//  Copyright 2014 James Meyer. All rights reserved.
//


#import "PEShapeCache.h"

static float area(CGPoint* verts, int vertCount) {
   
    int n = (vertCount-1);
	// calculate triangle between last and first vert
	float area = (verts[0].x*  verts[n].y) - (verts[n].x * verts[0].y);
    // calculate each quad individually and add to area
	for (int i=0; i<vertCount-1; ++i) {
		area += (verts[n-i].x * verts[n-(i+1)].y) - (verts[n-(i+1)].x * verts[n-i].y);
	}
    // multiply by half to get the triangle area from the quad
	area = area * 0.5f;
	return area;
}

typedef enum {
	POLYGON_FIXTURE,
	CIRCLE_FIXTURE,
    POLYLINE_FIXTURE
} FixtureType;

//**********************************************************************
// Holds details on individual polygons that make up shape
@interface Polygon : NSObject

@property CGPoint* vertices;
@property int numVertices;
@property float area;

@end

//************
@implementation Polygon

@end

//*********************************************************************
// Fixture definition to hold fixture data.  Most attributes are stored
//here, as well as polygons and hull verts.
@interface FixtureNode : NSObject

@property FixtureType fixtureType;
@property float mass;
@property float density;
@property float area;
@property float elasticity;
@property float friction;
@property CGPoint surfaceVelocity;
@property NSString* collisionType;
@property NSString* collisionGroup;
@property BOOL isSensor;
@property float cornerRadius;

// for circles
@property CGPoint center;
@property float radius;

// for solid polygons
@property NSMutableArray* polygons;

// for polygons made of polyLines
@property BOOL isPolylines;
@property CGPoint* polyPoints;
@property int numPolyPoints;

@end

//***************
@implementation FixtureNode

-(id)init {
	self = [super init];
    if (!self) return nil;
    
    self.polygons = [NSMutableArray array];
	
	return self;
}

@end

//***********************************************************************
// Body definition holds the ficture data, as well as booleans telling
// us if the body can rotate and respects gravity.  Also has anchor point for
// use when lining up a sprite
@interface BodyNode : NSObject

@property CGPoint anchorPoint;
@property NSMutableArray* fixtures;
@property BOOL canRotate;
@property BOOL obeyGravity;

@end

//************
@implementation BodyNode

-(id)init {
	self = [super init];
    if (!self) return nil;
		
    self.fixtures = [NSMutableArray array];
	
	return self;
}

@end

//***********************************************************************
// this is where all the body definitions are stored once the plist
// has been read and parsed.
@implementation PEShapeCache {
    NSMutableDictionary* _bodyNodes;
}

static PEShapeCache* shapeCache = nil;

-(id)init {
	self = [super init];
    if (!self) return nil;
    
	_bodyNodes = [[NSMutableDictionary alloc] init];
	
    return self;
}

+(PEShapeCache*)sharedShapeCache {
	if(shapeCache == nil) shapeCache = [[PEShapeCache alloc] init];

	return shapeCache;
}


// returns anchor point for use with a corresponding sprite
-(CGPoint)anchorPointForShape:(NSString*)shape {
    BodyNode *bn = [_bodyNodes objectForKey:shape];
    if (!bn) {
        CCLOG(@"Body not found for shape: %@",shape);
        return CGPointZero;
    }
    return bn.anchorPoint;
}

// Meat and potatoes here.  Returns a fully set up CCPhysicsBody, which also
// has its shapes attached.  This method creates the bodies as CCPhysicsShapes
// and uses the bodywithshapes: method for creating the body.  Most attributes
// are implemented through the shape, except for allowsRotation and
// affectedByGravity, which are exclusive to CCPhysicsBody
-(CCPhysicsBody*)bodyWithName:(NSString*)name {
	
	BodyNode* bn = [_bodyNodes objectForKey:name];
	if (!bn) {
        CCLOG(@"Body not found for name: %@",name);
        return nil;
    }
    
    // it puts the lotion (shapes) in the basket (array)
    NSMutableArray* shapes = [NSMutableArray array];
		
	// iterate over fixtures
	for (FixtureNode* fn in bn.fixtures) {
		if (fn.fixtureType == CIRCLE_FIXTURE) {
            CCPhysicsShape* shape = [CCPhysicsShape circleShapeWithRadius:fn.radius
                                                                   center:fn.center];

			// set property values
            shape.mass = fn.mass;
			shape.elasticity = fn.elasticity;
			shape.friction = fn.friction;
			shape.surfaceVelocity = fn.surfaceVelocity;
			shape.sensor = fn.isSensor;
			shape.collisionType = fn.collisionType;
			shape.collisionGroup = NSClassFromString(fn.collisionGroup);
            
            [shapes addObject:shape];
			
		} else if (fn.fixtureType == POLYGON_FIXTURE) {
			// iterate over polygons
			for (Polygon* poly in fn.polygons) {
				CCPhysicsShape* shape = [CCPhysicsShape polygonShapeWithPoints:poly.vertices
                                                                         count:poly.numVertices
                                                                  cornerRadius:fn.cornerRadius];
                // this one is different in that in order to keep the mass the
                // original amount, I calculated a density and apply that to the area
                // of each polygon in order to
                shape.mass = poly.area * fn.density;
                shape.elasticity = fn.elasticity;
                shape.friction = fn.friction;
                shape.surfaceVelocity = fn.surfaceVelocity;
                shape.sensor = fn.isSensor;
                shape.collisionType = fn.collisionType;
                shape.collisionGroup = NSClassFromString(fn.collisionGroup);
 
                [shapes addObject:shape];
            }
            
        } else if (fn.fixtureType == POLYLINE_FIXTURE) {
            for (int i = 0; i < fn.numPolyPoints; i++) {
				CGPoint point1 = fn.polyPoints[i];
				CGPoint point2 = fn.polyPoints[i+1];
				if (i + 1 == fn.numPolyPoints) point2 = fn.polyPoints[0];

                CCPhysicsShape* shape = [CCPhysicsShape pillShapeFrom:point1
                                                                   to:point2
                                                         cornerRadius:fn.cornerRadius];
                shape.mass = fn.mass;
                shape.elasticity = fn.elasticity;
                shape.friction = fn.friction;
                shape.surfaceVelocity = fn.surfaceVelocity;
                shape.sensor = fn.isSensor;
                shape.collisionType = fn.collisionType;
                shape.collisionGroup = NSClassFromString(fn.collisionGroup);
                
                [shapes addObject:shape];
            }
        }
    }
    
    CCPhysicsBody* body = [CCPhysicsBody bodyWithShapes:shapes];
    body.allowsRotation = bn.canRotate;
    body.affectedByGravity = bn.obeyGravity;
    
    return body;
}


-(BOOL)addPhysicsShapesWithFile:(NSString*)plist{
	
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:nil inDirectory:nil];

    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    if(!dictionary) {
        CCLOG(@"Unable to load file: %@", plist);
        return FALSE;
    }

    NSDictionary *metadataDict = [dictionary objectForKey:@"metadata"];
    int format = [[metadataDict objectForKey:@"format"] intValue];
    if(format != 1) {
        CCLOG(@"Format not supported");
        return FALSE;
    }

    NSDictionary* bodyDict = [dictionary objectForKey:@"bodies"];

    for(NSString* bodyName in bodyDict) {
        // get the body data
        NSDictionary *bData = [bodyDict objectForKey:bodyName];
        // create body object
        BodyNode* bNode = [[BodyNode alloc] init];
        // add the body element to the cache
        [_bodyNodes setObject:bNode forKey:bodyName];
        // set anchor point
        bNode.anchorPoint = CGPointFromString([bData objectForKey:@"anchorpoint"]);
        bNode.canRotate = [[bData objectForKey:@"canRotate"] boolValue];
        bNode.obeyGravity = [[bData objectForKey:@"obeyGravity"] boolValue];
        // iterate through the fixtures
        NSArray* fixtureList = [bData objectForKey:@"fixtures"];
        for(NSDictionary *fData in fixtureList) {
			// create fixture
			FixtureNode* fNode = [[FixtureNode alloc] init];
			if(!fNode) {
                return FALSE;
            }

            // add the fixture to the body
            [bNode.fixtures addObject:fNode];
            // vitals for shape
			fNode.friction = [[fData objectForKey:@"friction"] floatValue];
			fNode.elasticity = [[fData objectForKey:@"elasticity"] floatValue];
			fNode.mass = [[fData objectForKey:@"mass"] floatValue];
			fNode.surfaceVelocity = CGPointFromString([fData objectForKey:@"surface_velocity"]);
			fNode.collisionGroup = [fData objectForKey:@"collision_group"];
			fNode.collisionType = [fData objectForKey:@"collision_type"];
			fNode.isSensor = [[fData objectForKey:@"fixtureData"] boolValue];
            fNode.isPolylines = [[fData objectForKey:@"isPolylines"] boolValue];
            fNode.cornerRadius = [[fData objectForKey:@"cornerRadius"] intValue];
			
			NSString* fixtureType = [fData objectForKey:@"fixture_type"];
			
			// read polygon fixtures. One concave fixture may consist of several convex polygons
			if([fixtureType isEqual:@"POLYGON"] && (!fNode.isPolylines)) {
                
				fNode.fixtureType = POLYGON_FIXTURE;
                
                fNode.area = 0.0f;

				NSArray* polygonsArray = [fData objectForKey:@"polygons"];

				for(NSArray* polygonArray in polygonsArray) {
					Polygon* poly = [[Polygon alloc] init];
					if(!poly) {
						return FALSE;
					}

					// add the polygon to the fixture
					[fNode.polygons addObject:poly];

					// size the pointer to the vertices
					poly.numVertices = [polygonArray count];
					CGPoint* vertices = poly.vertices = malloc(sizeof(CGPoint) * poly.numVertices);
					if(!vertices) {
						return FALSE;
					}
                    
                    // iterate through the strings in the array and extract points
					int vindex = 0;
					for(NSString *pointString in polygonArray) {
						CGPoint offset = CGPointFromString(pointString);
						vertices[vindex].x = offset.x ; 
						vertices[vindex].y = offset.y ; 
						vindex++;
					}
                    
                    poly.area = area(poly.vertices, poly.numVertices);
                    fNode.area += poly.area;
				}
                
                fNode.density = fNode.mass/fNode.area;
                
			} else if([fixtureType isEqual:@"POLYGON"] && (fNode.isPolylines)) {
                
                fNode.fixtureType = POLYLINE_FIXTURE;
                
                NSArray* polyVerts = [fData objectForKey:@"hull"];
                
                // size the pointer to the vertices
                int numVertices = [polyVerts count];
                CGPoint* points = fNode.polyPoints = malloc(sizeof(CGPoint) * numVertices);
                if(!fNode.polyPoints) {
                    return FALSE;
                }
                
                // iterate through the strings in the array and extract points
                int vindex = 0;
                for (NSString *pointString in polyVerts) {
                    CGPoint offset = CGPointFromString(pointString);
                    points[vindex].x = offset.x ;
                    points[vindex].y = offset.y ;
                    vindex++;
                }
                
                fNode.numPolyPoints = vindex;

            } else if([fixtureType isEqual:@"CIRCLE"]) {
                
				fNode.fixtureType = CIRCLE_FIXTURE;

				NSDictionary* circleData = [fData objectForKey:@"circle"];

				fNode.center = CGPointFromString([circleData objectForKey:@"position"]);
				fNode.radius = [[circleData objectForKey:@"radius"] floatValue];
			} else {
				// unknown type
				assert(0);
			}
		}
	}
	return TRUE;
}

@end