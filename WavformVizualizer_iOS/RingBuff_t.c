//
//  RingBuff_t.c
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/17/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#include "RingBuff_t.h"
#include  <string.h>
#include "RingBuff_t.h"


unsigned int modulo_inc(const unsigned int value, const unsigned int modulus)
{
   unsigned int my_value = value + 1;
   if (my_value >= modulus)
   {
      my_value  = 0;
   }
   return my_value;
}


void ringBufS_init (ringBuf_t *_this)
{
   /*****
    The following clears:
    -> buf
    -> head
    -> tail
    -> count
    and sets head = tail
    ***/
   memset (_this, 0, sizeof(*_this));
}

int ringBufS_empty (ringBuf_t *_this)
{
   return (0 == _this->count);
}

int ringBufS_full (ringBuf_t *_this)
{
   return (_this->count>=RBUF_SIZE);
}


void ringBufS_flush(ringBuf_t *_this, const int clearBuffer)
{
   _this->count  = 0;
   _this->head   = 0;
   _this->tail   = 0;
   if (clearBuffer)
   {
      memset (_this->buf, 0, sizeof (_this->buf));
   }
}



float ringBufS_get(ringBuf_t *_this)
{
   float c;
   if (_this->count > 0)
   {
      c = _this->buf[_this->tail];
      _this->tail = modulo_inc(_this->tail, RBUF_SIZE);
      --_this->count;
   }
   else
   {
      c = -1;
   }
   return (c);
}


void ringBufS_put(ringBuf_t *_this, float c)
{
   if (_this->count < RBUF_SIZE)
   {
      _this->buf[_this->head] = c;
      _this->head = modulo_inc(_this->head, RBUF_SIZE);
      ++_this->count;
   }
}



