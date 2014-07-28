//
//  GRViewController.m
//  _23_GesturesTest
//
//  Created by Exo-terminal on 4/30/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRViewController.h"

@interface GRViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView* testView;
@property (assign, nonatomic) CGFloat testViewScale;
@property (assign, nonatomic) CGFloat testViewRotation;


@end

@implementation GRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 50,
                                                          CGRectGetMidY(self.view.bounds) - 50,
                                                          100, 100)];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    view.backgroundColor =[UIColor greenColor];
    
    [self.view addSubview:view];
    
    self.testView = view;
    
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self
                                                action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    UITapGestureRecognizer *doubleTapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self
                                    action:@selector(doubleHandleTap:)];
    
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    
    
    UITapGestureRecognizer *doubleTapDoubleTouchGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self
                                                  action:@selector(doubleHandleTapDoubleTouch:)];
    
    doubleTapDoubleTouchGesture.numberOfTapsRequired = 2;
    doubleTapDoubleTouchGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTapDoubleTouchGesture];
    
    UIPinchGestureRecognizer* pinchGestire =
    [[UIPinchGestureRecognizer alloc]initWithTarget:self
                                             action:@selector(handlePinch:)];
    pinchGestire.delegate = self;
    [self.view addGestureRecognizer:pinchGestire];
    
    
    UIRotationGestureRecognizer* rotationGesture =
    [[UIRotationGestureRecognizer alloc]initWithTarget:self
                                             action:@selector(handleRotation:)];
    rotationGesture.delegate = self;
    [self.view addGestureRecognizer:rotationGesture];
    
    UIPanGestureRecognizer* panGesture =
    [[UIPanGestureRecognizer alloc]initWithTarget:self
                                           action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    UISwipeGestureRecognizer* verticalSwipeGesture =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                           action:@selector(handleVerticalSwipe:)];
    verticalSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    verticalSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:verticalSwipeGesture];
    
    UISwipeGestureRecognizer* horisontalSwipeGesture =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                             action:@selector(handleHorisontalSwipe:)];
    horisontalSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft| UISwipeGestureRecognizerDirectionRight;
    horisontalSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:horisontalSwipeGesture];
    
}

#pragma mark - Methods -

-(UIColor*) randomColor{
    
    CGFloat r = (CGFloat)(arc4random() %256)/255;
    CGFloat g = (CGFloat)(arc4random() %256)/255;
    CGFloat b = (CGFloat)(arc4random() %256)/255;
    NSLog(@"%f, %f, %f",r,g,b);
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}


#pragma mark - Gesture -

-(void) handleTap: (UITapGestureRecognizer*) tapGesture{
    
    NSLog(@"Tap view %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    
    self.testView.backgroundColor = [self randomColor];
}

-(void) doubleHandleTap: (UITapGestureRecognizer*) doubleTapGesture{
    
    NSLog(@"Double Tap view %@", NSStringFromCGPoint([doubleTapGesture locationInView:self.view]));
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1.2f, 1.2f);
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.testView.transform = newTransform;
                     }];
     self.testViewScale = 1.2f;
    
}

-(void) doubleHandleTapDoubleTouch: (UITapGestureRecognizer*) doubleTapGesture{
    
//    NSLog(@"Double Tap Double Touch %@", NSStringFromCGPoint([doubleTapGesture locationInView:self.view]));
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 0.8f, 0.8f);
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.testView.transform = newTransform;
                     }];
    self.testViewScale = 0.8f;
}


-(void) handlePinch: (UIPinchGestureRecognizer*) pinchGesture{
    
//    NSLog(@"Pinch %1.3f",pinchGesture.scale);
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewScale = 1.f;
    }
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.testViewScale;
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform,newScale,newScale);

     self.testView.transform = newTransform;
    
    self.testViewScale = pinchGesture.scale;
}
-(void) handleRotation: (UIRotationGestureRecognizer*) rotationGesture{
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewRotation = 0;
    }
    
    CGFloat newRotation = rotationGesture.rotation - self.testViewRotation;
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate (currentTransform,newRotation);
    NSLog(@"handleRotation %1.3f",newRotation);

    
    self.testView.transform = newTransform;
    
    self.testViewRotation = rotationGesture.rotation;

}

-(void)handlePan:(UIPanGestureRecognizer*) panGesture{
    
      NSLog(@"handlePan");
    self.testView.center = [panGesture locationInView:self.view];
    
}

-(void)handleVerticalSwipe:(UISwipeGestureRecognizer*) swipeGesture{
//    NSLog(@"handleVerticalSwipe");
}

-(void)handleHorisontalSwipe:(UISwipeGestureRecognizer*) swipeGesture{
//    NSLog(@"handleHorisontalSwipe");
}
#pragma mark - UIGestureRecognizerDelegate -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
                          shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
                          shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]];
    
}


@end
