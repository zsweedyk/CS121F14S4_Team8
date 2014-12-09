//
//  Enums.h
//  PowerUP
//
//  Created by Sean on 12/1/14.
//  Copyright (c) 2014 CS121F14S4_Team8. All rights reserved.
//

#ifndef PowerUP_Enums_h
#define PowerUP_Enums_h

enum GAME_STATES {
    FIRST_TIME,
    NEED_TO_LEARN_SWITCH,
    NEED_TO_LEARN_SHORT,
    NEED_TO_LEARN_BOMB,
    NEED_TO_LEARN_LASER
};

enum LANGUAGES {
    ENGLISH,
    SPANISH,
    CHINESE
};

enum TYPE_OF_STORYVIEW {
    STORY,
    INSTRUCTION
};

enum COMPONENTS {
    EMPTY = 0,
    WIRE,
    EMITTER,
    BATTERY_NEG,
    BULB,
    RECEIVER,
    BATTERY_POS,
    SWITCH,
    DEFLECTOR,
    BOMB,
    LASER
};

enum DIRECTION {
    LEFT,
    RIGHT,
    BOTTOM,
    TOP,
    NONE
};

enum TOUCH_STATE {
    UNTOUCHED,
    STARTED_OUT_NOW_IN,
    STARTED_OUT_WAS_IN_NOW_OUT,
    STARTED_IN_NOW_IN,
    STARTED_IN_NOW_OUT
};

#endif
