//
//  gn_wav_reader.h
//  AudioDemo
//
//  Created by Bergren Lam on 7/15/14.
//  Copyright (c) 2014 Bergren Lam. All rights reserved.
//

#ifndef AudioDemo_gn_wav_reader_h
#define AudioDemo_gn_wav_reader_h

#ifdef __cplusplus
extern "C" {
#endif
    
    void* wav_read_open(const char *filename);
    void wav_read_close(void* obj);
    
    int wav_get_header(void* obj, int* format, int* channels, int* sample_rate, int* bits_per_sample, unsigned int* data_length);
    int wav_read_data(void* obj, unsigned char* data, unsigned int length);
    
#ifdef __cplusplus
}
#endif

#endif
