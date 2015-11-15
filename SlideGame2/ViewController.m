//
//  ViewController.m
//  SlideGame2
//
//  Created by Apple on 11/15/15.
//  Copyright © 2015 Yingyu Sun. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
NSMutableArray* allImgViews;
NSMutableArray* allCenters;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    allImgViews = [NSMutableArray new];
    allCenters = [NSMutableArray new];
    
    int xCenter = 95;
    int yCenter = 200;
    for ( int v =0; v < 3; v++) {
        
        for(int h = 0; h < 3; h++) {
            UIImageView* myImageView = [[UIImageView alloc] initWithFrame: CGRectMake(150, 150, 91, 91)];
            
            CGPoint currentCenter = CGPointMake(xCenter, yCenter);
            [allCenters addObject: [NSValue valueWithCGPoint:currentCenter]];
            myImageView.center = currentCenter;
            
            myImageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"jc_%02i.jpg", h+v*3]];
            myImageView.userInteractionEnabled = YES;
            [allImgViews addObject: myImageView];
            [self.view addSubview: myImageView];
            xCenter += 91;
        }
        
        xCenter = 95;
        yCenter += 91;
    }
    
    [[allImgViews objectAtIndex:0] removeFromSuperview];
    [allImgViews removeObjectAtIndex:0];
    
    // we have an array with all 15 imageviews and another array with all 16 centers
    
    [self randomizeBlocks];
}

- (IBAction)reset:(UIButton *)sender {
    [self randomizeBlocks];
}
CGPoint emptySpot;

-(void) randomizeBlocks{
    
    NSMutableArray* centersCopy = [allCenters mutableCopy];
    
    int randLocInt;
    CGPoint randLoc;
    
    for ( UIView* any in allImgViews) {
        randLocInt = arc4random() % centersCopy.count;
        randLoc = [[centersCopy objectAtIndex:randLocInt] CGPointValue];
        
        any.center = randLoc;
        [centersCopy removeObjectAtIndex:randLocInt];
    }
    emptySpot = [[centersCopy objectAtIndex:0] CGPointValue];
}

CGPoint tapCenter;
CGPoint left;
CGPoint right;
CGPoint top;
CGPoint bottom;
bool leftIsEmpty, rightIsEmpty, topIsEmpty, bottomIsEmpty;

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch* myTouch = [[touches allObjects] objectAtIndex:0];
    
    if(myTouch.view != self.view) {
        tapCenter = myTouch.view.center;
        left = CGPointMake(tapCenter.x - 91, tapCenter.y);
        right = CGPointMake(tapCenter.x +91, tapCenter.y);
        top = CGPointMake(tapCenter.x, tapCenter.y + 91);
        bottom = CGPointMake(tapCenter.x, tapCenter.y - 91);
        
        if( [[NSValue valueWithCGPoint:left] isEqual:[NSValue valueWithCGPoint:emptySpot]]) {
            
            leftIsEmpty = true;
        }
        if( [[NSValue valueWithCGPoint:right] isEqual:[NSValue valueWithCGPoint:emptySpot]]) {
            
            rightIsEmpty = true;
        }
        if( [[NSValue valueWithCGPoint:top] isEqual:[NSValue valueWithCGPoint:emptySpot]]) {
            
            topIsEmpty = true;
        }
        if( [[NSValue valueWithCGPoint:bottom] isEqual:[NSValue valueWithCGPoint:emptySpot]]) {
            
            bottomIsEmpty = true;
        }
        
        if( leftIsEmpty || rightIsEmpty || topIsEmpty || bottomIsEmpty)
        {
            [UIView beginAnimations:Nil context:NULL];
            [UIView setAnimationDuration:0.5];
            
            myTouch.view.center = emptySpot;
            
            [UIView commitAnimations];
            emptySpot = tapCenter;
            leftIsEmpty = false;
            rightIsEmpty = false;
            topIsEmpty = false;
            bottomIsEmpty = false;
        }
        
    }
}

@end
