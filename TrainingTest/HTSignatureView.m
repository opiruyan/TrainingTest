//
//  HTSignatureView.m
//  TrainingTest
//
//  Created by Oleg Piruyan on 4/3/17.
//  Copyright © 2017 Harbortouch. All rights reserved.
//

#import "HTSignatureView.h"

@interface HTSignatureView ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic) CGPoint previousPoint;

@end

@implementation HTSignatureView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.path = [UIBezierPath bezierPath];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.maximumNumberOfTouches = 1;
        pan.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint currentPoint = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        [self.path moveToPoint:currentPoint];
        // clean the form
        [self.delegate signatureViewDidStartEditing:self];
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint midPoint = midpoint(self.previousPoint, currentPoint);
        [self.path addQuadCurveToPoint:midPoint controlPoint:self.previousPoint];
    }
    self.previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

CGPoint midpoint(CGPoint a, CGPoint b)
{
    return CGPointMake((a.x + b.x) / 2, (a.y + b.y) / 2);
}

- (void)clearPath
{
    self.path = [UIBezierPath bezierPath];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIColor *color = [UIColor colorWithRed:95 green:101 blue:206 alpha:1];
    color = [UIColor blueColor];
    [color setStroke];
    [self.path stroke];
}


@end
