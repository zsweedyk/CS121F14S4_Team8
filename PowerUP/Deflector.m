//
//  Deflector.m
//  PowerUP
//
//  Created by Zehao Zhang on 14-11-8.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#import "Deflector.h"

<<<<<<< HEAD
@interface Deflector () {
    NSArray* possibleConnections;
    
    int numConnectionIndex;
    int currentConnection;
    int row;
    int col;
    
//    DirectionController* control;
    enum DIRECTION previousDir;
=======
@implementation Deflector
{
    NSArray *_possibleOrientations;
    NSArray *_twoWays;
    NSArray *_threeWays;
    NSArray *_fourWays;
    //the index for the current orientation
    int _currentOrientation;
    NSString *name;
    NSString *_orientation;
    //index for the current deflector type,
    //2 stands for two-way
    //3 stands for three-way
    //4 stands for four-way
    int _currentTypeIndex;
    
    int _row;
    int _col;
    
    UIImageView *_deflector;
    DirectionController *control;
    NSString* previousDir;
>>>>>>> PowerUP
}

@end

@implementation Deflector

const int POSITION_ENCODER = 100;
const int MIN_NUM_CONNECTIONS = 2;
const int MAX_NUM_CONNECTIONS = 4;

enum ROTATIONS {
    CLOCKWISE,
    COUNTER_CLOCKWISE,
    OPPOSITE_DIRECTION
};


#pragma mark - Initialization

- (id) initWithFrame:(CGRect)frame AtRow:(int)initRow AndCol:(int)initCol WithConnections:(NSString*)connections {
    
    self = [super initWithFrame:frame];
    
    //set previous direction to X if user drags the deflector for the first time
    
    row = initRow;
    col = initCol;
    
<<<<<<< HEAD
    [self setUpConnectionData];
    [self initialConnectionSetUp:connections];
=======
    _twoWays   = [[NSArray alloc] initWithObjects:@"XRTX",@"XRXB",@"LXXB",@"LXTX",nil];
    _threeWays = [[NSArray alloc] initWithObjects:@"LRTX",@"XRTB",@"LRXB",@"LXTB", nil];
    _fourWays  = [[NSArray alloc] initWithObjects:@"LRTB", nil];
    _possibleOrientations = _twoWays;
    _currentTypeIndex   = 2;
    _currentOrientation = 0;
    _orientation = _possibleOrientations[_currentOrientation];
    name = [NSString stringWithFormat: @"deflector%@", _possibleOrientations[_currentOrientation]];
>>>>>>> PowerUP
    
    [self setUpImageNameWithConnections:possibleConnections[numConnectionIndex][currentConnection]];
    [self displayImage];
    
    return self;
}

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void) setUpConnectionData {
    
    NSArray *twoWays = [[NSArray alloc] initWithObjects:@"XRTX",@"XRXB",@"LXXB",@"LXTX",nil];
    NSArray *threeWays = [[NSArray alloc] initWithObjects:@"LRTX",@"XRTB",@"LRXB",@"LXTB", nil];
    NSArray *fourWays = [[NSArray alloc] initWithObjects:@"LRTB", nil];
    
    possibleConnections = [[NSArray alloc] initWithObjects:twoWays, threeWays, fourWays, nil];
}

- (void) initialConnectionSetUp:(NSString*)initialConnection {
    
    if ([possibleConnections[0] containsObject:initialConnection]) {
        numConnectionIndex = 0;
    } else if ([possibleConnections[1] containsObject:initialConnection]) {
        numConnectionIndex = 1;
    } else if ([possibleConnections[2] containsObject:initialConnection]) {
        numConnectionIndex = 2;
    } else {
        numConnectionIndex = 0;
        currentConnection = 0;
        return;
    }
<<<<<<< HEAD
=======
    _currentOrientation = 0;
    name = [NSString stringWithFormat: @"deflector%@", _possibleOrientations[_currentOrientation]];
    _deflector.image = [UIImage imageNamed:name];
    _orientation = _possibleOrientations[_currentOrientation];
    NSArray *position = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_row], [NSNumber numberWithInt:_col], nil];
    previousDir = @"X";
    [self.delegate performSelector:@selector(deflectorSelectedAtPosition:WithOrientation:) withObject:position withObject:_orientation];
>>>>>>> PowerUP
    
    NSInteger connectionIndex = [possibleConnections[numConnectionIndex] indexOfObject:initialConnection];
    currentConnection = [[NSNumber numberWithInteger:connectionIndex] intValue];
}

//- (void) setUpDirectionController {
//    control = [[DirectionController alloc] initWithFrame:self.frame];
//    control.delegate = self;
//    
//    [self addSubview:control];
//}

- (void) setUpImageNameWithConnections:(NSString*)connections {
    self.imageName = [NSString stringWithFormat:@"deflector%@",connections];
}

- (void) deflectorChanged {
    NSString *connections = possibleConnections[numConnectionIndex][currentConnection];
    
    int position = 100*row + col;
    
    [self.delegate performSelector:@selector(deflectorSelectedAtPosition:WithConnections:) withObject:[NSNumber numberWithInt:position] withObject:connections];
}

- (void) tapped
{
    switch (numConnectionIndex) {
        case 0:
        case 1:
            ++numConnectionIndex;
            break;
        case 2:
            numConnectionIndex = 0;
            break;
        default:
            break;
    }

    currentConnection = 0;
    
    [self.image removeFromSuperview];
    [self setUpImageNameWithConnections:possibleConnections[numConnectionIndex][currentConnection]];
    [self displayImage];
}

- (void) rotateDeflector:(enum ROTATIONS)rotation {
    
    switch (rotation) {
        case CLOCKWISE:
            ++currentConnection;
            if (currentConnection == [possibleConnections[numConnectionIndex] count]) {
                currentConnection = 0;
            }
            break;
            
        case COUNTER_CLOCKWISE:
            --currentConnection;
            if (currentConnection < 0) {
                currentConnection = 0;
            }
            break;
            
        case OPPOSITE_DIRECTION:
            [self rotateDeflector:CLOCKWISE];
            [self rotateDeflector:CLOCKWISE];
            break;
            
        default:
            break;
    }
}

- (void) changeConnection:(enum DIRECTION)dir {
    
    if ((previousDir == RIGHT && dir == TOP) || (previousDir == LEFT && dir == BOTTOM) || (previousDir == TOP && dir == LEFT) || (previousDir == BOTTOM && dir == RIGHT)) {
        
        [self rotateDeflector:COUNTER_CLOCKWISE];
        
    } else if ((previousDir == RIGHT && dir == BOTTOM) || (previousDir == LEFT && dir == TOP) || (previousDir == TOP && dir == RIGHT) || (previousDir == BOTTOM && dir == LEFT)) {
        
        [self rotateDeflector:CLOCKWISE];
        
    } else if ((previousDir == RIGHT && dir == LEFT) || (previousDir == LEFT && dir == RIGHT) || (previousDir == TOP && dir == BOTTOM) || (previousDir == BOTTOM && dir == TOP)) {
        
        [self rotateDeflector:OPPOSITE_DIRECTION];
    }
    
    previousDir = dir;
    
    [self.image removeFromSuperview];
    [self setUpImageNameWithConnections:possibleConnections[numConnectionIndex][currentConnection]];
    [self displayImage];
    NSLog(@"Parameters in deflector. Position:%@, and connection:%@",[NSNumber numberWithInt:[self getPosition]], possibleConnections[numConnectionIndex][currentConnection]);
    [self.delegate performSelector:@selector(deflectorAdjustedAtPosition:ToConnection:) withObject:[NSNumber numberWithInt:[self getPosition]] withObject:possibleConnections[numConnectionIndex][currentConnection]]
    ;
}

- (int) getPosition {
    return POSITION_ENCODER*row + col;
}

#pragma mark - Touch Handling

CGPoint start;
CGPoint current;


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    start = [touch locationInView:self];
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    current = [touch locationInView:self];
    
    int dx = start.x - current.x;
    int dy = start.y - current.y;
    
    if (abs(dx) > abs(dy)) {
        if (dx > 0) {
            [self changeConnection:LEFT];
        } else {
            [self changeConnection:RIGHT];
        }
    } else {
        if (dy > 0) {
            [self changeConnection:TOP];
        } else {
            [self changeConnection:BOTTOM];
        }
    }
}

<<<<<<< HEAD
=======
- (void) turnOn
{
    NSString *onName = [name stringByAppendingString:@"on"];
    
    _deflector.image = [UIImage imageNamed:onName];
    
}
>>>>>>> PowerUP

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];

    if (touch.tapCount == 1) {
        [self tapped];
        return;
    }
    
    previousDir = NONE;
    [self deflectorChanged];
}

@end
