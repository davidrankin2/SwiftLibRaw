#include <libraw.h>

/*
  =============================================================================
  MIT License

  Copyright (c) 2025 David W. Rankin, Jr.

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  =============================================================================
 */

uint16_t SwiftLibRaw_glue_get2u(void *stream) {
	size_t returnedSize;
    uint16_t buffer;
    returnedSize = ((LibRaw_abstract_datastream *)stream)->read(&buffer, 1, 
    		sizeof(uint16_t) );
    if (returnedSize != sizeof(uint16_t)) {
        printf("returnedSize %lu size %lu mismatch", returnedSize,
        		sizeof(uint16_t));
        return 0;
    }
    return buffer;
}

uint32_t SwiftLibRaw_glue_get4u(void *stream) {
	size_t returnedSize;
    uint32_t buffer;
    returnedSize = ((LibRaw_abstract_datastream *)stream)->read(&buffer, 1, 
    		sizeof(uint32_t) );
    if (returnedSize != sizeof(uint32_t)) {
        printf("returnedSize %lu size %lu mismatch", returnedSize,
        		sizeof(uint32_t));
        return 0;
    }
    return buffer;
}

void *SwiftLibRaw_glue_fread(size_t size, void *stream) {
	size_t returnedSize;
    void *buffer = malloc(size);
    if (!buffer) {
        printf("malloc fail");
    	return NULL;
    }
    returnedSize = ((LibRaw_abstract_datastream *)stream)->read(buffer, 1, size);
    if (returnedSize != size) {
        printf("returnedSize %lu size %lu mismatch", returnedSize, size);
    	free(buffer);
        return NULL;
    }
    return buffer;
}
