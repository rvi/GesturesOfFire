//
//  RVViewController.m
//  GesturesOfFire
//
//  Created by Rémy on 29/12/12.
//  Copyright (c) 2012 Rémy Virin. All rights reserved.
//

#import "RVViewController.h"

// Views
#import "RVFireView.h"

@interface RVViewController ()

@property (nonatomic, strong) NSMutableArray *fireViews;

@end

@implementation RVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.fireViews = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add tap gesture to create fires
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapRecognized:)];
    [self.view addGestureRecognizer:tap];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
    // Remove gesture
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers)
    {
        [self.view removeGestureRecognizer:gesture];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)fireViewContainsTap:(UITapGestureRecognizer *)tap {
    
    BOOL result = NO;
    
    for (RVFireView *fireView in self.fireViews)
    {
        CGPoint tapPoint = [tap locationInView:fireView];
        
        if (tapPoint.x >= 0 &&
            tapPoint.y >= 0 &&
            tapPoint.x < fireView.frame.size.width &&
            tapPoint.x < fireView.frame.size.height)
        {
            result = YES;
            break;
        }
    }
    
    return result;
}

- (void)tapRecognized:(id)sender {
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
        CGPoint tapPoint = [tap locationInView:self.view];
        
        if ([self fireViewContainsTap:tap])
        {
            //forward tap to view
        }
        else
        {
            RVFireView *fireView = [RVFireView view];
            [self.fireViews addObject:fireView];
            
            [fireView setCenter:tapPoint];
            [self.view addSubview:fireView];
        }
    }
}


@end
