//
//  PuzzleViewController.m
//  4x4Puzzle
//
//  Created by 5shrimp on 24.08.14.
//  Copyright (c) 2014 S&L. All rights reserved.
//

#import "PuzzleViewController.h"
#import "Puzzle.h"

@implementation PuzzleViewController

@synthesize baseView;
@synthesize base;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.base = [[Puzzle alloc] init];
    [base shuffle:STEPS_COUNT];
    [self buildBaseView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)pieceChosen:(UIButton*)sender
{
    const int tag = [sender tag];
    int row, column;
    [base getRow:&row Column:&column ForPiece:tag];
    CGRect buttonFrame = sender.frame;
    
    if ([base canMovePieceAtRow:row Column:column]) {
        WAY way = [base movePieceAtRow:row Column:column];
        switch (way) {
            case UP:
                buttonFrame.origin.y = (row-1)*buttonFrame.size.height;
                break;
            case DOWN:
                buttonFrame.origin.y = (row+1)*buttonFrame.size.height;
                break;
            case LEFT:
                buttonFrame.origin.x = (column-1)*buttonFrame.size.width;
                break;
            case RIGHT:
                buttonFrame.origin.x = (column+1)*buttonFrame.size.width;
                break;
            default:
                break;
        }
        [UIView animateWithDuration:0.5 animations:^{sender.frame = buttonFrame;}];
        
        if ([base isCorrect]) {
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
    [base shuffle:STEPS_COUNT];
    [self buildBaseView];
}

-(void)buildBaseView
{
    const CGRect baseBounds = baseView.bounds;
    const CGFloat pieceWidth = baseBounds.size.width / 4.0;
    const CGFloat pieceHeight = baseBounds.size.width / 4.0;
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 4; column++) {
            const int piece = [base getPieceAtRow:row Column:column];
            if (piece > 0) {
                __weak UIButton *button = (UIButton *)[baseView viewWithTag:piece];
                button.frame = CGRectMake(column*pieceWidth, row*pieceHeight, pieceWidth, pieceHeight);
            }
        }
    }
}

@end
