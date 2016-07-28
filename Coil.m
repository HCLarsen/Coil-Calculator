//
//  Coil.m
//  Coil Calculator
//
//  Created by Chris Larsen on 12-01-07.
//  Copyright 2012 Chris Larsen. All rights reserved.
//


#import "Coil.h"
#import "PhysicsConsts.h"

@implementation Coil

@synthesize coreLength;
@synthesize dim1, dim2;
@synthesize wireDiameter, awg, leadLength;
@synthesize coreShape;
@synthesize relativePermeability;
@synthesize frequency, current;

#pragma mark Basic Methods

-(float)perimeter{
	float perimeter = 0;
	
	if (coreShape == 0) {
		perimeter = Pi * (self.dim1 + self.wireDiameter);
	} else if (coreShape == 1) {
		perimeter = (self.dim1 + self.wireDiameter) * 4;
	} else if (coreShape == 2) {
		perimeter = (self.dim1 + self.dim2) * 2 + self.wireDiameter * 4;
	}
	
	return perimeter;	
}

-(int)maxTurns{
	return self.coreLength/self.wireDiameter;
}

-(float)wireLength{
	return self.perimeter * self.maxTurns + self.leadLength * 2;
}

#pragma mark Advanced Methods

-(float)area {
	float area = 0;
	
	if (coreShape == 0) {		// cylinder
		float radius = self.dim1 / 2;
		area = Pi * radius * radius;
	} else if (coreShape == 1) {	// square
		area = self.dim1 * self.dim1;
	} else if (coreShape == 2) {	// rectangle
		area = self.dim1 * self.dim2;
	}
	
	return area;
}

-(float)inductance {
	float ind = 0;
	
	ind = pow(self.maxTurns, 2) * Uo * self.relativePermeability * self.area / self.coreLength;
	
	return ind;
}

#pragma mark Behavioural Methods
-(float)magneticFieldDensity {
	return (self.relativePermeability * Uo * self.maxTurns * self.current / self.coreLength);
}

-(float)resistance {
	// will first use Copper as the default, then may add the ability to select
	// other wire materials.
	
	NSLog(@"%i", self.awg);
	float resistivity = 1.678 * 10e-8; // nanoOhms/metre	
	float awgFloat = self.awg;	// integer won't calculate properly, AWG must be converted to a float
	float wireArea = 0.012668 * pow(92, (36-awgFloat)/19.5);
	
	return resistivity * self.wireLength / wireArea; 
}

-(float)inductiveReactance {
	return (2*Pi*self.frequency*self.inductance);
}

-(float)qFactor {
	return self.inductiveReactance / self.resistance;
}


@end
