//
//  PuzzleViewController.h
//  4x4Puzzle
//
//  Created by 5shrimp on 24.08.14.
//  Copyright (c) 2014 S&L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Puzzle.h"


@interface PuzzleViewController : UIViewController

@property(weak,nonatomic) IBOutlet UIView *baseView;

-(IBAction)pieceChosen:(UIButton*)sender;
-(IBAction)newGame:(id)sender;
-(void)buildBaseView;
-(void)gameResult;

@end
