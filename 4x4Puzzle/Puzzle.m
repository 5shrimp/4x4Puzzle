//
//  Puzzle.m
//  4x4Puzzle
//
//  Created by 5shrimp on 24.08.14.
//  Copyright (c) 2014 S&L. All rights reserved.
//

#import "Puzzle.h"

@implementation Puzzle

/**
 * We have to initialize a new base grid for puzzle (in correct way order). Only once - when the puzzle is instantiated.
 */
-(id)init
{
    if (self = [super init]) {
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++)
                base[i][j] = i*4+(j+1);
        base[3][3] = 0;
    }
    return self;
}

/**
 * Here I choose one of the "moveble" pieces of puzzle as random, move it into empty space and repeat it (n) times.
 */
-(void)shuffle:(int)n
{
    for (int i = 0; i < n; i++) {
        int row, column;
        do {
            row = rand() % 4;
            column = rand() % 4;
        } while(![self canMovePieceAtRow:row Column:column]);
        [self movePieceAtRow:row Column:column];
    }
}

/**
 * Fetch the piece of puzzle at the given position. (0 is used for the space)
 */
-(int)getPieceAtRow:(int)row Column:(int)column
{
    return base[row][column];
}

/**
 * Important thing to do - to find the position of the given piece.
 */
-(void)getRow:(int*)row Column:(int*)column ForPiece:(int)piece
{
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 4; j++)
            if (base[i][j] == piece) {
                (*row) = i; (*column) = j;
            }
                
}

/**
 * If puzzle is sorted in correct order.
 */
-(BOOL)isCorrect
{
    for (int i = 0; i < 15; i++) {
        int row = i / 4;
        int column = i % 4;
        if (base[row][column] != ((i+1)%16))
            return NO;
    }

    return YES;
}

/**
 * If the specified piece can be moved from its position.
 */
-(BOOL)canMovePieceAtRow:(int)row Column:(int)column
{
    return [self canMovePieceUpAtRow:row Column:column] ||
        [self canMovePieceDownAtRow:row Column:column] ||
        [self canMovePieceLeftAtRow:row Column:column] ||
        [self canMovePieceRightAtRow:row Column:column];
}

/**
 * If the piece can be moved up into the empty space.
 */
-(BOOL)canMovePieceUpAtRow:(int)row Column:(int)column
{
    return row > 0 && base[row-1][column] == 0;
}

-(BOOL)canMovePieceDownAtRow:(int)row Column:(int)column
{
    return row < 3 && base[row+1][column] == 0;
}

-(BOOL)canMovePieceLeftAtRow:(int)row Column:(int)column
{
    return column > 0 && base[row][column-1] == 0;
}

-(BOOL)canMovePieceRightAtRow:(int)row Column:(int)column
{
    return column < 3 && base[row][column+1] == 0;
}

/**
 * Piece movement into the empty space.
 */
-(WAY)movePieceAtRow:(int)row Column:(int)column
{
    int tmp = base[row][column];
    WAY moved = EMPTY;
    if ([self canMovePieceUpAtRow:row Column:column]) {
        base[row][column] = base[row-1][column];
        base[row-1][column] = tmp;
        moved = UP;
    } else if ([self canMovePieceDownAtRow:row Column:column]) {
        base[row][column] = base[row+1][column];
        base[row+1][column] = tmp;
        moved = DOWN;
    } else if ([self canMovePieceLeftAtRow:row Column:column]) {
        base[row][column] = base[row][column-1];
        base[row][column-1] = tmp;
        moved = LEFT;
    } else if ([self canMovePieceRightAtRow:row Column:column]) {
        base[row][column] = base[row][column+1];
        base[row][column+1] = tmp;
        moved = RIGHT;
    }
    return moved;
}

@end
