//
//  functions.h
//  WaveForm2
//
//  Created by alexanderbollbach on 2/12/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#ifndef functions_h
#define functions_h


#include <AudioToolbox/AudioToolbox.h>


#include <stdio.h>


float alexMap(float input, float input_start, float input_end, float output_start, float output_end);
void CheckError(OSStatus error, const char *operation);


#endif /* functions_h */
