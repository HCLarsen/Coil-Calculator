//
//  Coil_CalculatorAppDelegate.h
//  Coil Calculator
//
//  Created by Chris Larsen on 11-06-19.
//  Copyright 2011 home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Coil.h"
#import "PhysicsConsts.h"
#import "CLMetricFormatter.h"

@interface Coil_CalculatorAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
		
	NSPopUpButton *coreShapeButton;
	
	NSTextField *coreDim1Field;	// Basic entry fields
	NSTextField *coreDim1Label;
	NSTextField *coreDim2Field;
	NSTextField *coreDim2Label;
	NSTextField *coreLengthField;
	NSTextField *wireSizeField;
	NSTextField *leadLengthField;

	NSTextField *relativePermField;	// Advanced entry field

	NSPopUpButton *awgButton;			// Behavioural entry fields
	
	NSTextField *frequencyField;
	NSTextField *currentField;
	
	NSTextField *maxTurnsField;
	NSTextField *wireLengthField;
	NSTextField *inductanceField;
	NSTextField *magneticFieldDensityField;
	NSTextField *reactanceField;
	NSTextField *resistanceField;
	NSTextField *qFactorField;
	
	Coil *aCoil;
	int calculatorType;
	
	NSView *basicView;
	NSView *advancedView;
	NSView *behaviouralView;
	
	NSMutableArray *mandatoryFields;	
}

-(void)resizeWindowFrom:(NSSize)currentSize to:(NSSize)newSize;
-(BOOL)checkMandatoryFields;

-(IBAction)selectView:(id)sender;
-(IBAction)selectCoreShape:(id)sender;
-(IBAction)calculate:(id)sender;

@property (assign) Coil *aCoil;
@property (assign) IBOutlet NSWindow *window;
@property (assign) NSMutableArray *mandatoryFields;

@property (assign) IBOutlet NSView *basicView, *advancedView, *behaviouralView;
@property (assign) IBOutlet NSPopUpButton *coreShapeButton;
@property (assign) IBOutlet NSTextField *coreDim1Field, *coreDim1Label;
@property (assign) IBOutlet NSTextField *coreDim2Field, *coreDim2Label, *coreLengthField;
@property (assign) IBOutlet NSTextField *relativePermField;
@property (assign) IBOutlet NSPopUpButton *awgButton;
@property (assign) IBOutlet NSTextField *currentField, *frequencyField;
@property (assign) IBOutlet NSTextField *wireSizeField, *leadLengthField;
@property (assign) IBOutlet NSTextField *maxTurnsField, *wireLengthField, *inductanceField;
@property (assign) IBOutlet NSTextField *magneticFieldDensityField, *reactanceField, *resistanceField, *qFactorField;

@end
