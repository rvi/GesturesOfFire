//
//  RVFireView.m
//  GesturesOfFire
//
//  Created by Rémy on 01/01/13.
//  Copyright (c) 2013 Rémy Virin. All rights reserved.
//

#import "RVFireView.h"

#import <QuartzCore/CoreAnimation.h>

#define MAX_PIN_SCALE 7.0
#define MIN_FIRE_VALUE 0.6
#define MAX_FIRE_VALUE 2.0

@interface RVFireView ()

@property (strong) CAEmitterLayer *fireEmitter;
@property (strong) CAEmitterLayer *smokeEmitter;

- (void) controlFireHeight:(id)sender;
- (void) setFireAmount:(float)zeroToOne;


@end

@implementation RVFireView

/**************************************************************************************************/
#pragma mark - Birth and Death

+ (RVFireView *)view
{
	RVFireView *view = nil;
	
	NSArray *topLevelsObjects = [[NSBundle mainBundle] loadNibNamed:@"RVFireView" owner:nil options:nil];
	for(id currentObject in topLevelsObjects)
    {
		if([currentObject isKindOfClass:[RVFireView class]])
        {
			view = (RVFireView *)currentObject;
            [view initFire];
			break;
		}
	}
    
    return view;
}

- (void)initFire
{
    CGRect viewBounds = self.layer.bounds;
    
    // Create the emitter layers
    self.fireEmitter	= [CAEmitterLayer layer];
    self.smokeEmitter	= [CAEmitterLayer layer];
    
    // Place layers just above the tab bar
    self.fireEmitter.emitterPosition = self.center;
    self.fireEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0);
    self.fireEmitter.emitterMode	= kCAEmitterLayerOutline;
    self.fireEmitter.emitterShape	= kCAEmitterLayerLine;
    // with additive rendering the dense cell distribution will create "hot" areas
    self.fireEmitter.renderMode		= kCAEmitterLayerAdditive;
    
    self.smokeEmitter.emitterPosition = self.center;
    self.smokeEmitter.emitterMode	= kCAEmitterLayerPoints;
    
    // Create the fire emitter cell
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    [fire setName:@"fire"];
    
    fire.birthRate			= 100;
    fire.emissionLongitude  = M_PI;
    fire.velocity			= -160;
    fire.velocityRange		= 60;
    fire.emissionRange		= 1.1;
    fire.yAcceleration		= -200;
    fire.scaleSpeed			= 0.3;
    fire.lifetime			= 50;
    fire.lifetimeRange		= (50.0 * 0.35);
    
    fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
    fire.contents = (id) [[UIImage imageNamed:@"DazFire"] CGImage];
    
    
    // Create the smoke emitter cell
    CAEmitterCell* smoke = [CAEmitterCell emitterCell];
    [smoke setName:@"smoke"];
    
    smoke.birthRate			= 11;
    smoke.emissionLongitude = -M_PI / 2;
    smoke.lifetime			= 10;
    smoke.velocity			= -40;
    smoke.velocityRange		= 20;
    smoke.emissionRange		= M_PI / 4;
    smoke.spin				= 1;
    smoke.spinRange			= 6;
    smoke.yAcceleration		= -160;
    smoke.contents			= (id) [[UIImage imageNamed:@"DazSmoke"] CGImage];
    smoke.scale				= 0.1;
    smoke.alphaSpeed		= -0.12;
    smoke.scaleSpeed		= 0.7;
    
    
    // Add the smoke emitter cell to the smoke emitter layer
    self.smokeEmitter.emitterCells	= [NSArray arrayWithObject:smoke];
    self.fireEmitter.emitterCells	= [NSArray arrayWithObject:fire];
    [self.layer addSublayer:self.smokeEmitter];
    [self.layer addSublayer:self.fireEmitter];
    
    [self setFireAmount:0.9];
    
    [self setClipsToBounds:NO];
    [self setNeedsDisplay];
}

/**************************************************************************************************/
#pragma mark - Actions

- (IBAction)viewPinched:(id)sender {
    
    if ([sender isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)sender;

        CGFloat fireFactor = pinch.scale / MAX_PIN_SCALE * (MAX_FIRE_VALUE - MIN_FIRE_VALUE);
        fireFactor += MIN_FIRE_VALUE;
        fireFactor = MIN(fireFactor, MAX_FIRE_VALUE);
        
        NSLog(@"fire : %f, pinch : %f",fireFactor,pinch.scale);
        [self setFireAmount:fireFactor];
    }
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIDeviceOrientationPortrait);
}


// ---------------------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Interaction
// ---------------------------------------------------------------------------------------------------------------


- (void) controlFireHeight:(UIEvent *)event
{
	UITouch *touch			= [[event allTouches] anyObject];
	CGPoint touchPoint		= [touch locationInView:self];
	float distanceToBottom	= self.bounds.size.height - touchPoint.y;
	float percentage		= distanceToBottom / self.bounds.size.height;
	percentage				= MAX(MIN(percentage, 1.0), 0.1);
	[self setFireAmount:2 *percentage];
}


- (void) setFireAmount:(float)zeroToOne
{
	// Update the fire properties
	[self.fireEmitter setValue:[NSNumber numberWithInt:(zeroToOne * 500)]
					forKeyPath:@"emitterCells.fire.birthRate"];
	[self.fireEmitter setValue:[NSNumber numberWithFloat:zeroToOne]
					forKeyPath:@"emitterCells.fire.lifetime"];
	[self.fireEmitter setValue:[NSNumber numberWithFloat:(zeroToOne * 0.35)]
					forKeyPath:@"emitterCells.fire.lifetimeRange"];
	self.fireEmitter.emitterSize = CGSizeMake(50 * zeroToOne, 0);
	
	[self.smokeEmitter setValue:[NSNumber numberWithInt:zeroToOne * 4]
					 forKeyPath:@"emitterCells.smoke.lifetime"];
	[self.smokeEmitter setValue:(id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:zeroToOne * 0.3] CGColor]
					 forKeyPath:@"emitterCells.smoke.color"];
}

@end
