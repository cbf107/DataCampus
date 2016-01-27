//
//  gn_wav_wirter.h
//  AudioDemo
//
//  Created by Bergren Lam on 7/15/14.
//  Copyright (c) 2014 Bergren Lam. All rights reserved.
//

#ifndef AudioDemo_gn_wav_wirter_h
#define AudioDemo_gn_wav_wirter_h


#include <stdio.h>


#ifdef __cplusplus
extern "C" {
#endif
    
    void* wav_write_open(const char *filename, int sample_rate, int bits_per_sample, int channels);
    void wav_write_close(void* obj);
    
    void wav_write_data(void* obj, const unsigned char* data, int length);
    
#ifdef __cplusplus
}
#endif




#endif
