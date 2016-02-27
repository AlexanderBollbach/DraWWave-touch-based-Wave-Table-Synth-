//
//  functions.c
//  WaveForm2
//
//  Created by alexanderbollbach on 2/12/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#include "functions.h"

float alexMap(float input, float input_start, float input_end, float output_start, float output_end) {
   
   return ((input - input_start)/(input_end - input_start)) * (output_end - output_start) + output_start;

}

 void CheckError(OSStatus error, const char *operation) {
   if (error == noErr) return;
   
   char str[20];
   // see if it appears to be a 4-char-code
   *(UInt32 *)(str + 1) = CFSwapInt32HostToBig(error);
   if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
      str[0] = str[5] = '\'';
      str[6] = '\0';
   } else
      // no, format it as an integer
      sprintf(str, "%d", (int)error);
   
   fprintf(stderr, "Error: %s (%s)\n", operation, str);
   
   exit(1);
}