
// Copyright © 2025 David W. Rankin Jr.

// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files
// (the "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import OSLog
import libraw
import libraw_glue

// Faster just to use a compiler test here. Still setting a variable because
// it's easier than using compiler spaghetti code. The compiler should 
// optimize the code well.
#if _endian(little)
private let amILittleIndian = true
#elseif _endian(big)
private let amILittleIndian = false
#endif

// exif callback function
private let exif_callback : exif_parser_callback = { (context: Optional<UnsafeMutableRawPointer>, tag: Int32, type: Int32, len: Int32, ord: UInt32, ifp: Optional<UnsafeMutableRawPointer>, base: Int64) in
	// void exif_callback(void *context, int tag, int type, int len, unsigned int ord, void *ifp) 
	// self is context 

	// print("Running callback function")
    // print("Tag " + String(format:"%02X", tag as Int32) + " Type " + String(type) + " Length " + String(len) + " ord " + String(ord) )
            
    let returnself: SwiftLibRaw = Unmanaged<SwiftLibRaw>.fromOpaque(context!).takeUnretainedValue()
    let conversion = taghandler(type: type, len: len, fileIsLittleEnd: (ord == 0x4d4d), ifp: ifp)
    // 
    returnself.metadata[tag] = conversion
    // print(returnself)
}

private func get2u(ifp: Optional<UnsafeMutableRawPointer>, fileIsLittleEnd: Bool) -> UInt16 {
    // Use glue code in C to efficiently read a uint16
    let intdata = SwiftLibRaw_glue_get2u(ifp)
    // If the endian is swapped, swap it back.
	if (fileIsLittleEnd != amILittleIndian) {
        // Using compiler magic to save an if/else
        #if _endian(little)
        	return intdata.littleEndian
        #elseif _endian(big)
        	return intdata.bigEndian
        #endif
    } else {
        return intdata
    }
}

private func get4u(ifp: Optional<UnsafeMutableRawPointer>, fileIsLittleEnd: Bool) -> UInt32 {
    // Use glue code in C to efficiently read a uint32
    let intdata = SwiftLibRaw_glue_get4u(ifp)
    // If the endian is swapped, swap it back.
	if (fileIsLittleEnd != amILittleIndian) {
        // Using compiler magic to save an if/else
        #if _endian(little)
        	return intdata.littleEndian
        #elseif _endian(big)
        	return intdata.bigEndian
        #endif
    } else {
        return intdata
    }
}

private func taghandler(type: Int32, len: Int32, fileIsLittleEnd: Bool, ifp: Optional<UnsafeMutableRawPointer> ) -> Any {

	switch type {
    	case 7: // Undefined, it's functionally identical to byte...
        	fallthrough
    	case 1: // BYTE
    		let buffer = SwiftLibRaw_glue_fread(Int(len), ifp)
    		return Data(bytesNoCopy: buffer!, count: Int(len), deallocator: .free)
    	case 2: // ASCII
        	fallthrough
    	case 129: // ASCII
    		let buffer = SwiftLibRaw_glue_fread(Int(len), ifp)
    		let mydata = Data(bytesNoCopy: buffer!, count: Int(len), deallocator: .free)
            return String(decoding: mydata, as: UTF8.self)
        case 3: // Short
        	var retarray = [UInt16]()
            for _ in 0..<len {
                let retval = get2u(ifp: ifp, fileIsLittleEnd: fileIsLittleEnd)
        		if (len == 1) {
                	return retval
                } else {
                	retarray.append(retval)
                }
            }
            return retarray
        case 4: // long
        	var retarray = [UInt32]()
            for _ in 0..<len {
                let retval = get4u(ifp: ifp, fileIsLittleEnd: fileIsLittleEnd)
        		if (len == 1) {
                	return retval
                } else {
                	retarray.append(retval)
                }
            }
            return retarray
        case 5: // rational
        	var retvaluearray = [Double]()
        	var retnumarray = [UInt]()
        	var retdenomarray = [UInt]()
            for _ in 0..<len {
                let numerator = get4u(ifp: ifp, fileIsLittleEnd: fileIsLittleEnd)
                let denominator = get4u(ifp: ifp, fileIsLittleEnd: fileIsLittleEnd)
                let value = Double(numerator) / (denominator != 0 ? Double(denominator) : 1 )
        		if (len == 1) {
                	return (value, UInt(numerator), UInt(denominator))
                } else {
                    retvaluearray.append(value)
                    retnumarray.append(UInt(numerator))
                	retdenomarray.append(UInt(denominator))
                }
            }
            return (retvaluearray, retnumarray, retdenomarray)
        case 9: // slong
        	var retarray = [Int32]()
            for _ in 0..<len {
                let retval = Int32(get4u(ifp: ifp, fileIsLittleEnd: fileIsLittleEnd))
        		if (len == 1) {
                	return retval
                } else {
                	retarray.append(retval)
                }
            }
            return retarray
        case 10: // srational
        	var retvaluearray = [Double]()
        	var retnumarray = [Int]()
        	var retdenomarray = [Int]()
            for _ in 0..<len {
                let numerator = Int32(get4u(ifp: ifp, fileIsLittleEnd: fileIsLittleEnd))
                let denominator = Int32(get4u(ifp: ifp, fileIsLittleEnd: fileIsLittleEnd))
                let value = Double(numerator) / (denominator != 0 ? Double(denominator) : 1 )
        		if (len == 1) {
                	return (value, Int(numerator), Int(denominator))
                } else {
                    retvaluearray.append(value)
                    retnumarray.append(Int(numerator))
                	retdenomarray.append(Int(denominator))
                }
            }
            return (retvaluearray, retnumarray, retdenomarray)
        default:
        	return "unsupported"
	}
}

public class SwiftLibRaw {
    
    // Allow nil to emulate NULL
    var cBuffer: UnsafeMutablePointer<libraw_data_t>?

    fileprivate var metadata: Dictionary<Int32, Any>

    let objlock = OSAllocatedUnfairLock()

    // Clean up after oneself. 
    public func error_cleanup(result: Int32) {
        self.objlock.lock()
        if (self.cBuffer == nil) {
        	return
        }
        if (result != LIBRAW_SUCCESS.rawValue) {
            if #available(OSX 11.0, *) {
                let defaultLog = Logger()
                let errorMessage = String(cString: libraw_strerror(result))
                defaultLog.log("LibRaw error: \(errorMessage)")
            }
            libraw_recycle_datastream(self.cBuffer!)
            libraw_recycle(self.cBuffer!)
            libraw_close(self.cBuffer!)
            self.cBuffer = nil
        }
        self.objlock.unlock()
    }

    // Making this a conditional allows me to scan a file and return a
    // null if it's not really an image.
    //
    // Technically init isn't thread-safe, but we should be OK here.
    //
    public init?(fileUrl: URL, options:Dictionary<String, Any>? = nil, userexif_callback: exif_parser_callback? = nil, userexif_object:Optional<UnsafeMutableRawPointer> = nil ) {

        var flags : UInt32 = 0
        if (options != nil && options!["No_Dataerr_Callback"] != nil) {
            // Swift right now can't do enum -> int, so we have to translate...
        	flags = 1
        }
        // Populate cBuffer first, and save it for later.
        self.cBuffer = libraw_init(flags)

        if (self.cBuffer == nil) {
            return nil
        }

        self.metadata = Dictionary<Int32,Any>()

        // Collect Metadata

        let ptr_to_self = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

        //print("Setting callback function")
        if (userexif_callback != nil && userexif_object != nil) {
        	libraw_set_exifparser_handler(self.cBuffer!, userexif_callback, userexif_object)
        } else if (options != nil && options!["library_exifparser"] != nil) {
        	libraw_set_exifparser_handler(self.cBuffer!, exif_callback, ptr_to_self)
        } 

        // Open the file, return a nil object if it fails.
        // print("Opening File")
        let result = libraw_open_file(self.cBuffer!, fileUrl.path)
        
        if (result != LIBRAW_SUCCESS.rawValue) {
            if #available(OSX 11.0, *) {
                let defaultLog = Logger()
                let errorMessage = String(cString: libraw_strerror(result))
                defaultLog.log("LibRaw error: \(errorMessage)")
            }
            libraw_close(self.cBuffer!)
            return nil
        }

        print("Unpacking function")
        let result2 = libraw_unpack(self.cBuffer!)
        if (result2 != LIBRAW_SUCCESS.rawValue) {
            if #available(OSX 11.0, *) {
                let defaultLog = Logger()
                let errorMessage = String(cString: libraw_strerror(result2))
                defaultLog.log("LibRaw error: \(errorMessage)")
            }
            libraw_close(self.cBuffer!)
            return nil
        }
    }

    public func get_metadata() -> Dictionary<Int32, Any> {
        // Not locked, because no one is now writing on this data.
    	return self.metadata
    }

    public func get_metadata(tag: Int32) -> Any? {
        // Not locked, because no one is now writing on this data.
    	return self.metadata[tag]
    }

    public func get_imgother() -> SLW_imgother? {
    	if(self.cBuffer == nil){
        	return nil
        }
        self.objlock.lock()
        let returnval = SLW_imgother(cStruct: libraw_get_imgother(self.cBuffer))
        self.objlock.unlock()
        return returnval
    }

    public func get_lensinfo() -> SLW_lensinfo? {
    	if(self.cBuffer == nil){
        	return nil
        }
        self.objlock.lock()
        let returnval = SLW_lensinfo(cStruct: libraw_get_lensinfo(self.cBuffer))
        self.objlock.unlock()
        return returnval
    }

    public func get_iparams() -> SLW_iparams? {
    	if(self.cBuffer == nil){
        	return nil
        }
        self.objlock.lock()
        let returnval = SLW_iparams(cStruct: libraw_get_iparams(self.cBuffer))
        self.objlock.unlock()
        return returnval
    }

    public func get_cam_mul(index: Int32) -> Float { 
        self.objlock.lock()
        let returnval = libraw_get_cam_mul(self.cBuffer, index)
        self.objlock.unlock()
        return returnval
    }

    public func get_pre_mul(index: Int32) -> Float {
        self.objlock.lock()
        let returnval = libraw_get_pre_mul(self.cBuffer, index)
        self.objlock.unlock()
        return returnval
    }

    public func get_rgb_cam(index1: Int32, index2: Int32) -> Float {
        self.objlock.lock()
        let returnval = libraw_get_rgb_cam(self.cBuffer, index1, index2)
        self.objlock.unlock()
        return returnval
    }

    public func get_raw_height() -> Int32 {
        self.objlock.lock()
        let returnval = libraw_get_raw_height(self.cBuffer)
        self.objlock.unlock()
        return returnval
    }
    
    public func get_raw_width() -> Int32 {
        self.objlock.lock()
        let returnval = libraw_get_raw_width(self.cBuffer)
        self.objlock.unlock()
        return returnval

    }

    public func get_iheight() -> Int32 {
        self.objlock.lock()
        let returnval = libraw_get_iheight(self.cBuffer)
        self.objlock.unlock()
        return returnval
    }

    public func get_iwidth() -> Int32 {
        self.objlock.lock()
        let returnval = libraw_get_iwidth(self.cBuffer)
        self.objlock.unlock()
        return returnval
    }

    // Clean up after oneself. 
    deinit {
        if (self.cBuffer != nil) {
        	libraw_recycle_datastream(self.cBuffer!)
        	libraw_recycle(self.cBuffer!)
        	libraw_close(self.cBuffer!)
        }
    }
    
}
