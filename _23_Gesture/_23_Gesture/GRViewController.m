//
//  GRViewController.m
//  _23_Gesture
//
//  Created by Exo-terminal on 5/1/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRViewController.h"

@interface GRViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic)UIImageView* animationView;
@property (assign, nonatomic) float distance;
@property (strong, nonatomic)UIView* myView;
@property (assign, nonatomic)float rotation;
@property (assign, nonatomic)BOOL animation;
@property (strong, nonatomic) NSMutableArray* array;
@property (assign, nonatomic)float testViewScale;
@property (assign, nonatomic)float testViewRotation;


@end

@implementation GRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage* paper = [UIImage imageNamed:@"background.jpg"];
    UIImageView* background = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame),
                                                                           CGRectGetMinY(self.view.frame),
                                                                           CGRectGetHeight(self.view.frame),
                                                                           CGRectGetHeight(self.view.frame))];
    
    background.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    background.image = paper;
    
    [self.view addSubview:background];
    
    self.animationView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100,
                                                                     CGRectGetMidY(self.view.bounds) - 100,
                                                                     200, 200)];
    self.animationView.image = [UIImage imageNamed:@"penguin_8.png"];
    self.array = [[NSMutableArray alloc]init];
    for (int i = 1 ; i < 11 ; i++) {
        
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"penguin_%d",i]];
        [self.array addObject:image];
    }
    self.animation = YES;
    
    self.animationView.animationImages = self.array;
    self.animationView.animationDuration = 1.8f;
    self.animationView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview:self.animationView];
    [self.animationView startAnimating];
    
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(doubleHandleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    UISwipeGestureRecognizer* leftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                          action:@selector(leftHadleSwipe:)];
    leftSwipeGesture.direction =  UISwipeGestureRecognizerDirectionLeft;
    leftSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer* rightSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                          action:@selector(rightHadleSwipe:)];
    rightSwipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
    rightSwipeGesture.delegate = self;
    [self.view addGestureRecognizer:rightSwipeGesture];
    
    UIRotationGestureRecognizer* rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self
                                                                                               action:@selector(handleRotation:)];
    rotationGesture.delegate = self;
    [self.view addGestureRecognizer:rotationGesture];
    
    UIPinchGestureRecognizer* pinchCesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self
                                                                                      action:@selector(handlePinch:)];
   [self.view addGestureRecognizer:pinchCesture];
    
}

-(void)handleRotation: (UIRotationGestureRecognizer*) rotationGesture{
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewRotation = 0;
    }
    
    CGFloat newRotation = rotationGesture.rotation - self.testViewRotation;
    
    CGAffineTransform currentTransform = self.animationView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate (currentTransform,newRotation);
//    NSLog(@"handleRotation %1.3f",newRotation);
    
    
    self.animationView.transform = newTransform;
    
    self.testViewRotation = rotationGesture.rotation;
    
}
-(void)handlePinch: (UIPinchGestureRecognizer*)pinchCesture{
    
    if (pinchCesture.state == UIGestureRecognizerStateBegan) {
        self.testViewScale = 1.f;
    }
    
    CGFloat newScale = 1.f + pinchCesture.scale - self.testViewScale;
    
    CGAffineTransform currentTransform = self.animationView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.animationView.transform = newTransform;
    self.testViewScale = pinchCesture.scale;
    
    
}
-(void) handleTap: (UITapGestureRecognizer*) tapGesture{
    
    if (tapGesture.state == UIGestureRecognizerStateBegan) {
        self.distance = 0;
    }
    
    float scale = arc4random() % 200;
    scale = scale/100;
  
//    NSLog(@"%.4f", scale);
    
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                           self.animationView.center =[tapGesture locationInView:self.view];
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void) doubleHandleTap: (UITapGestureRecognizer*) tapGesture {
    
    if (self.animation) {
        [self.animationView.layer removeAllAnimations];
        self.animation = NO;
    }else{
       [self.animationView startAnimating];
       self.animation = YES;
    }
}

-(void)leftHadleSwipe: (UISwipeGestureRecognizer*) swipeGesture{

    [self rotationViewСlockwise:NO];
    
}

-(void)rightHadleSwipe: (UISwipeGestureRecognizer*) swipeGesture{
    
    [self rotationViewСlockwise:YES];
    
}

-(void) rotationViewСlockwise: (BOOL) clockwise{
    
    double begin = 0;
    double end = ((360*M_PI)/180);
    
    
    [self.animationView.layer removeAnimationForKey:@"360"];
    
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:begin];
    fullRotation.toValue = [NSNumber numberWithFloat:end];
    fullRotation.duration = 2;
    fullRotation.repeatCount = 1;
    
    if(clockwise){
        fullRotation.fromValue = [NSNumber numberWithFloat:end];
        fullRotation.toValue = [NSNumber numberWithFloat:begin];
    }
    
    [self.animationView.layer addAnimation:fullRotation forKey:@"360"];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

/*-(void) rotationView: (UIView*) viewRotation rotationAngel: (double) angelRotation andFullCircle: (BOOL) fullCircle{
    CGAffineTransform currentTransform = viewRotation.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, angelRotation);
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         viewRotation.transform = newTransform;
         
                     } completion:^(BOOL finished) {
                         __weak UIView* minorView = viewRotation;
                         if (fullCircle) {
                             [self rotationView:minorView rotationAngel:angelRotation andFullCircle:FALSE];
                         }
                         
                     }];
}*/

@end
