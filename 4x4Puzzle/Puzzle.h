//
//  Puzzle.h
//  4x4Puzzle
//
//  Created by 5shrimp on 24.08.14.
//  Copyright (c) 2014 S&L. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STEPS_COUNT 88

#define WAY int
#define EMPTY 100
#define UP (EMPTY+1)
#define DOWN (UP+1)
#define LEFT (DOWN+1)
#define RIGHT (LEFT+1)

@interface Puzzle: NSObject {
    int base[4][4];
}

-(id)init;
-(void)shuffle:(int)n;
-(int)getPieceAtRow:(int)row Column:(int)column;
-(void)getRow:(int*)row Column:(int*)column ForPiece:(int)piece;
-(BOOL)isCorrect;

-(BOOL)canMovePieceAtRow:(int)row Column:(int)column;
-(BOOL)canMovePieceUpAtRow:(int)row Column:(int)column;
-(BOOL)canMovePieceDownAtRow:(int)row Column:(int)column;
-(BOOL)canMovePieceLeftAtRow:(int)row Column:(int)column;
-(BOOL)canMovePieceRightAtRow:(int)row Column:(int)column;
-(WAY)movePieceAtRow:(int)row Column:(int)column;

@end
