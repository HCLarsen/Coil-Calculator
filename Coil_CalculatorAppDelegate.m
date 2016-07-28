//
//  Coil_CalculatorAppDelegate.m
//  Coil Calculator
//
//	This class is mainly a controller for both the method and view.  With only one window, I see little point in creating a separate viewController.
//
//  Created by Chris Larsen on 11-06-19.
//  Copyright 2011 home. All rights reserved.
//

#import "Coil_CalculatorAppDelegate.h"

#define BasicTag		131
#define AdvancedTag		132
#define BehaviouralTag	133

@implementation Coil_CalculatorAppDelegate

@synthesize window;
@synthesize aCoil;
@synthesize mandatoryFields;
@synthesize basicView, advancedView, behaviouralView;
@synthesize coreShapeButton;
@synthesize coreDim1Field, coreDim2Field, coreLengthField;
@synthesize coreDim1Label, coreDim2Label;
@synthesize relativePermField;
@synthesize awgButton, currentField, frequencyField;
@synthesize wireSizeField, leadLengthField;
@synthesize maxTurnsField, wireLengthField, inductanceField;
@synthesize magneticFieldDensityField, reactanceField, resistanceField, qFactorField;

-(void)resizeWindowFrom:(NSSize)currentSize to:(NSSize)newSize {
	// Since Apple's origin is the bottom left, and resizing looks better with the upper left corner anchored, a little code is needed to make it right.
	
	float deltaWidth = newSize.width - currentSize.width;
	float deltaHeight = newSize.height - currentSize.height;
	NSRect windowFrame = [window frame];
	windowFrame.size.height += deltaHeight;
	windowFrame.origin.y -= deltaHeight;
	windowFrame.size.width += deltaWidth;
	
	[window setFrame:windowFrame display:YES animate:YES];
}

-(BOOL)checkMandatoryFields {
	for (NSTextField *field in mandatoryFields) {
		if ([[field stringValue] isEqual:@""]) {
			NSAlert *alert = [[[NSAlert alloc] init] autorelease];
			[alert addButtonWithTitle:@"OK"];
			[alert setMessageText:@"Missing Information"];
			NSString *string = [NSString stringWithFormat:@"A required field is currently blank."];
			[alert setInformativeText:string];
			[alert setAlertStyle:NSWarningAlertStyle];
			
			[alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
			return NO;
		}
	}
	
	return YES;
}

-(IBAction)selectCoreShape:(id)sender {
	// When the user selects the shape of the coil's core, this method changes the values of the entry field labels and adjusts the visibility of the second field.
	if (coreShapeButton.indexOfSelectedItem == 0) {	// Cyclinder
		[coreDim1Label setStringValue:@"Diameter:"];
		[coreDim2Label setHidden:YES];
		[coreDim2Field setHidden:YES];
		[mandatoryFields removeObjectIdenticalTo:coreDim2Field];
	} else if (coreShapeButton.indexOfSelectedItem == 1) {	// Square
		[coreDim1Label setStringValue:@"Width:"];
		[coreDim2Label setHidden:YES];
		[coreDim2Field setHidden:YES];
		[mandatoryFields removeObjectIdenticalTo:coreDim2Field];
	} else if (coreShapeButton.indexOfSelectedItem == 2) {	// Rectangle
		[coreDim1Label setStringValue:@"Width:"];
		[coreDim2Label setHidden:NO];
		[coreDim2Field setHidden:NO];
		[mandatoryFields addObject:coreDim2Field];
	}
}

-(IBAction)calculate:(id)sender {
	// Ensure that all mandatory fields contain values
	if (![self checkMandatoryFields]) return;
	
	// Get entered values, and divide them by 1000 to convert to metres
	[aCoil setDim1:[coreDim1Field floatValue]/1000];
	[aCoil setDim2:[coreDim2Field floatValue]/1000];
	[aCoil setCoreLength:[coreLengthField floatValue]/1000];
	[aCoil setLeadLength:[leadLengthField floatValue]/1000];
	[aCoil setCoreShape:coreShapeButton.indexOfSelectedItem];
	
	[aCoil setWireDiameter:wireSizeField.floatValue/1000];
	
	// Send the calculated values to the display
	[maxTurnsField setIntValue:aCoil.maxTurns];
	[wireLengthField setFloatValue:aCoil.wireLength];
	
	if (calculatorType == AdvancedTag) {
		[aCoil setRelativePermeability:[relativePermField floatValue]];
		
		[inductanceField setFloatValue:aCoil.inductance];
	} else if (calculatorType == BehaviouralTag) {
		[aCoil setRelativePermeability:[relativePermField floatValue]];
		[aCoil setAwg:[awgButton indexOfSelectedItem]-3];
		[aCoil setFrequency:[frequencyField floatValue]];
		[aCoil setCurrent:[currentField floatValue]];
		
		[inductanceField setFloatValue:aCoil.inductance];
		[reactanceField setFloatValue:aCoil.inductiveReactance];
		[magneticFieldDensityField setFloatValue:aCoil.magneticFieldDensity];
		[resistanceField setFloatValue:aCoil.resistance];
		[qFactorField setFloatValue:aCoil.qFactor];
	}
}

-(IBAction)selectView:(id)sender {
	int coreNumber = [coreShapeButton indexOfSelectedItem];	// saves the index so that it can be reselected after new view is loaded
	NSMenuItem *curItem = [[sender menu] itemWithTag:calculatorType];
	[curItem setState:NSOffState];
	[sender setState:NSOnState];

	NSSize currentSize = [[window contentView] frame].size;
	NSSize newSize;
	int coreShape = coreShapeButton.indexOfSelectedItem;
	
	if ([sender tag] == BasicTag) {
		[NSBundle loadNibNamed:@"Basic" owner:self];
		newSize = basicView.frame.size;
		[coreShapeButton selectItemAtIndex:coreShape];
		[self selectCoreShape:coreShapeButton];
		[window setContentView:basicView];
		
		[[[[self wireLengthField] cell] formatter] setUnit:@"m"];

		[self setMandatoryFields:[NSMutableArray arrayWithObjects:coreDim1Field, coreLengthField, relativePermField, nil]];
	} else if ([sender tag] == AdvancedTag) {
		[NSBundle loadNibNamed:@"Advanced" owner:self];
		newSize = advancedView.frame.size;
		[coreShapeButton selectItemAtIndex:coreShape];
		[self selectCoreShape:coreShapeButton];
		[window setContentView:advancedView];
		
		[[[[self wireLengthField] cell] formatter] setUnit:@"m"];
		[[[[self inductanceField] cell] formatter] setUnit:@"H"];

		[self setMandatoryFields:[NSMutableArray arrayWithObjects:coreDim1Field, coreLengthField, relativePermField, wireSizeField, nil]];
	} else if ([sender tag] == BehaviouralTag) {
		[NSBundle loadNibNamed:@"Behavioural" owner:self];
		newSize = behaviouralView.frame.size;
		[coreShapeButton selectItemAtIndex:coreShape];
		[self selectCoreShape:coreShapeButton];
		[window setContentView:behaviouralView];
		
		[[[[self wireLengthField] cell] formatter] setUnit:@"m"];
		[[[[self inductanceField] cell] formatter] setUnit:@"H"];
		[[[[self reactanceField] cell] formatter] setUnit:@"Ω"];
		[[[[self magneticFieldDensityField] cell] formatter] setUnit:@"T"];
		[[[[self resistanceField] cell] formatter] setUnit:@"Ω"];
		
		for (int i=1; i<=40; i++) {
			[awgButton addItemWithTitle:[NSString stringWithFormat:@"%d", i]];
		}
		
		[self setMandatoryFields:[NSMutableArray arrayWithObjects:coreDim1Field, coreLengthField, relativePermField, wireSizeField, frequencyField, currentField, nil]];
	}

	[self resizeWindowFrom:currentSize to:newSize];
	[coreDim1Field becomeFirstResponder];
	calculatorType = [sender tag];
	[coreShapeButton selectItemAtIndex:coreNumber];
}

- (BOOL)validateMenuItem:(NSMenuItem *)item {
    NSInteger tag = [item tag];
	if (tag == BasicTag || tag == AdvancedTag || tag == BehaviouralTag) {
		return YES;
	}
	
	return YES;
}

-(NSString *)supportFile {
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *dir = [NSString stringWithFormat:@"%@/Coil Calculator", path];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:dir]) {
		[fileManager createDirectoryAtPath:dir 
			   withIntermediateDirectories:YES 
								attributes:nil 
									 error:nil];
	}
	
	return [dir stringByAppendingPathComponent:@"CoilCalculator.data"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	aCoil = [[Coil alloc] init];	
	NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:self.supportFile];
	
	calculatorType = [[dictionary objectForKey:@"view"] intValue];
	if (!calculatorType) calculatorType = BasicTag;
	
	NSMenuItem *viewItem = [[NSApp mainMenu] itemWithTitle:@"View"];
	NSMenuItem *loadItem = [[viewItem submenu] itemWithTag:calculatorType];
	[self selectView:loadItem];
		
	[coreShapeButton selectItemAtIndex:[[dictionary objectForKey:@"core"] intValue]];
	[self selectCoreShape:[coreShapeButton selectedItem]];

	for (int i=1; i<=40; i++) {
		[awgButton addItemWithTitle:[NSString stringWithFormat:@"%d", i]];
	}
	
	[window makeKeyAndOrderFront:nil];	
}

-(void)applicationWillTerminate:(NSNotification *)notification {
	// Saving the view selection and core shape selection before closing
	NSNumber *viewNumber = [NSNumber numberWithInt:calculatorType];
	NSNumber *coreNumber = [NSNumber numberWithInt:[coreShapeButton indexOfSelectedItem]];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:viewNumber, @"view", coreNumber, @"core", nil];
	[NSKeyedArchiver archiveRootObject:dictionary toFile:self.supportFile];
}

@end
