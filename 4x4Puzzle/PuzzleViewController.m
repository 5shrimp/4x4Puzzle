//
//  PuzzleViewController.m
//  4x4Puzzle
//
//  Created by 5shrimp on 24.08.14.
//  Copyright (c) 2014 S&L. All rights reserved.
//

#import "PuzzleViewController.h"

static const NSUInteger kPuzzleShuffleStepsCount = 88;

@interface PuzzleViewController()
@property(strong,nonatomic) Puzzle *base;
@end

@implementation PuzzleViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.base = [[Puzzle alloc] initWithSize:4];
    [self newGame:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)pieceChosen:(UIButton*)sender
{
    const NSInteger tag = [sender tag];
    
    PuzzlePoint point = [self.base pointForValue:(PuzzleValue)tag];
    
    if ([self.base canMovePieceAtPoint:point]) {
        
        CGRect buttonFrame = sender.frame;
        
        PuzzleMovementDirection direction = [_base movePieceAtPoint:point];
        
        switch (direction) {
            case PuzzleMovementDirectionUp:
                buttonFrame = CGRectOffset(buttonFrame, 0, -CGRectGetHeight(buttonFrame));
                break;
                
            case PuzzleMovementDirectionDown:
                buttonFrame = CGRectOffset(buttonFrame, 0, +CGRectGetHeight(buttonFrame));
                break;
                
            case PuzzleMovementDirectionLeft:
                buttonFrame = CGRectOffset(buttonFrame, -CGRectGetWidth(buttonFrame), 0);
                break;

            case PuzzleMovementDirectionRight:
                buttonFrame = CGRectOffset(buttonFrame, +CGRectGetWidth(buttonFrame), 0);
                break;
                
            case PuzzleMovementDirectionNone:
                break;
        }
        
        [UIView animateWithDuration:0.25f animations:^{sender.frame = buttonFrame;}];
        
        if ([self.base isCorrect]) {
            [self gameResult];
        }
    }
}

/* Pff.. */
-(void)gameResult {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                      message:@"You have won!"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

-(IBAction)newGame:(id)sender
{
    [self.base shuffle:kPuzzleShuffleStepsCount];
    [self buildBaseView];
}

-(void)buildBaseView
{
    const CGRect baseBounds = self.baseView.bounds;
    const CGFloat pieceWidth = baseBounds.size.width / 4.0;
    const CGFloat pieceHeight = baseBounds.size.width / 4.0;
    for (int row = 0; row < [self.base size]; row++) {
        for (int column = 0; column < [self.base size]; column++) {
            const int piece = [self.base valueAtPoint:PuzzlePointMake(row, column)];
            if (piece > 0) {
                UIButton *button = (UIButton *)[self.baseView viewWithTag:piece];
                button.frame = CGRectMake(column*pieceWidth, row*pieceHeight, pieceWidth, pieceHeight);
            }
        }
    }
}

@end
