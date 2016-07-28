//
//  Coil.h
//  Coil Calculator
//
//  Created by Chris Larsen on 12-01-07.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Coil : NSObject {
	int coreShape;	// 0 for cylinder, 1 for square, 2 for rectangular
	float coreLength;
	float dim1;
	float dim2;
	
	float wireDiameter;
	int awg;
	float leadLength;

	int relativePermeability;
	
	float frequency;
	float current;
}

-(float)perimeter;
-(int)maxTurns;
-(float)wireLength;
-(float)area;
-(float)inductance;
-(float)inductiveReactance; // need frequency in order to calculate
-(float)resistance;	// could accept copper wire as the standard, but could also allow selection
-(float)qFactor;
-(float)magneticFieldDensity;	// need current to calculate that

@property (readwrite) int coreShape;
@property (readwrite) float coreLength;
@property (readwrite) float dim1;
@property (readwrite) float dim2;

@property (readwrite) float wireDiameter;
@property (readwrite) int awg;
@property (readwrite) float leadLength;

@property (readwrite) int relativePermeability;

@property (readwrite) float frequency;
@property (readwrite) float current;

@end
