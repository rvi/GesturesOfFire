//
//  RVFireView.h
//  GesturesOfFire
//
//  Created by Rémy on 01/01/13.
//  Copyright (c) 2013 Rémy Virin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RVFireView : UIView

/**************************************************************************************************/
#pragma mark - Birth & Death

+ (RVFireView *)view;

/**************************************************************************************************/
#pragma mark - Actions

- (IBAction)viewPinched:(id)sender;

@end
