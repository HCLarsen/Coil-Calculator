//
//  CLMetricFormatter.h
//  MetricFormatterTester
//
//  Created by Chris Larsen on 12-03-11.
//  Copyright 2012 Chris Larsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CLMetricFormatter : NSNumberFormatter {
	NSString *unit;
}

-(NSString *)metricStringFromFloat:(float)value;

@property (assign) NSString *unit;

@end
