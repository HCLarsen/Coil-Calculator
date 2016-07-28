//
//  CLMetricFormatter.m
//  MetricFormatterTester
//
//  Created by Chris Larsen on 12-03-11.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import "CLMetricFormatter.h"

@implementation CLMetricFormatter

@synthesize unit;

-(id)init {
	[super init];
	
	[self setMaximumFractionDigits:3];
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	[super init];
	
	[self setMaximumFractionDigits:3];
	
	return self;	
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	[super encodeWithCoder:aCoder];
}

-(NSString *)metricStringFromFloat:(float)value {
	NSString *suffix;
	
	if (value == 0) {
		suffix = [NSString stringWithFormat:@"%@", [self unit]];
	} else if (value >= 1000000000000) {
		value /= 1000000000000;
		suffix = [NSString stringWithFormat:@"T%@", [self unit]];
	} else if (value >= 1000000000) {
		value /= 1000000000;
		suffix = [NSString stringWithFormat:@"G%@", [self unit]];
	} else if (value >= 1000000) {
		value /= 1000000;
		suffix = [NSString stringWithFormat:@"M%@", [self unit]];
	} else if (value >= 1000) {
		value /= 1000;
		suffix = [NSString stringWithFormat:@"k%@", [self unit]];
	} else if (value < 0.000001) {
		value *= 1000000000;
		suffix = [NSString stringWithFormat:@"n%@", [self unit]];
	} else if (value < 0.001) {
		value *= 1000000;
		suffix = [NSString stringWithFormat:@"u%@", [self unit]];
	} else if (value < 1) {
		value *= 1000;
		suffix = [NSString stringWithFormat:@"m%@", [self unit]];
	}  else {
		suffix = [NSString stringWithFormat:@"%@", [self unit]];
	}

	return [NSString stringWithFormat:@"%.2f %@", value, suffix];	
}

-(NSString *)stringForObjectValue:(id)obj {
	return [self metricStringFromFloat:[obj floatValue]];
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
	*anObject = string;
	
	return YES;
}

@end
