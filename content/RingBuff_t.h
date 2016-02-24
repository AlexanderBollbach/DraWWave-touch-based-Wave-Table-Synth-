#ifndef __RINGBUFS_H
#define __RINGBUFS_H
#define RBUF_SIZE    (10000)

typedef struct ringBufS {
   
   float buf[RBUF_SIZE];
   int head;
   int tail;
   int count;
   
} ringBuf_t;

   void ringBufS_init(ringBuf_t *_this);
   int ringBufS_empty(ringBuf_t *_this);
   int ringBufS_full(ringBuf_t *_this);
   float ringBufS_get(ringBuf_t *_this);
   void ringBufS_put(ringBuf_t *_this, float c);
   void ringBufS_flush(ringBuf_t *_this, const int clearBuffer);

#endif