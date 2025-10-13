
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


extension libraw_iparams_t {
    var string_guard: String {
        return withUnsafePointer(to: self.guard) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
    }
    var string_make: String {
        return withUnsafePointer(to: self.make) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
    }
    var string_model: String {
        return withUnsafePointer(to: self.model) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
    }
    var string_software: String {
        return withUnsafePointer(to: self.software) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
    }
    var string_normalized_make: String {
        return withUnsafePointer(to: self.normalized_make) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
    }
    var string_normalized_model: String {
        return withUnsafePointer(to: self.normalized_model) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
    }
    var string_cdesc: String {
        return withUnsafePointer(to: self.cdesc) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
    }
    var data_xmpdata: Data {
        return Data(bytes: self.xmpdata, count: Int(self.xmplen))
    }
}

public struct SLW_iparams {
    public let guard_string: String
    public let make: String
    public let model: String
    public let software: String
    public let normalized_make: String
    public let normalized_model: String
    public let maker_index: UInt
    public let raw_count: UInt
    public let dng_version: UInt
    public let is_foveon: Bool
    public let colors: Int
    public let filters: UInt
    public let xtrans: Any
    public let xtrans_abs: Any
    public let cdesc: String
    public let xmplen: UInt
    public let xmpdata: Data
  
    init?(cStruct: UnsafeMutablePointer<libraw_iparams_t>?) {
    	if (cStruct == nil) {
        	return nil
        }
		self.guard_string = cStruct!.pointee.string_guard 
		self.make = cStruct!.pointee.string_make 
		self.model = cStruct!.pointee.string_model 
		self.software = cStruct!.pointee.string_software 
		self.normalized_make = cStruct!.pointee.string_normalized_make 
		self.normalized_model = cStruct!.pointee.string_normalized_model 
		self.cdesc = cStruct!.pointee.string_cdesc 
        self.maker_index = UInt(cStruct!.pointee.maker_index)
        self.raw_count = UInt(cStruct!.pointee.raw_count)
        self.dng_version = UInt(cStruct!.pointee.dng_version)
        self.is_foveon = (cStruct!.pointee.is_foveon != 0)
        self.colors = Int(cStruct!.pointee.colors)
        self.filters = UInt(cStruct!.pointee.filters)
        self.xmplen = UInt(cStruct!.pointee.xmplen)
        self.xmpdata = cStruct!.pointee.data_xmpdata
		self.xtrans = cStruct!.pointee.xtrans 
		self.xtrans_abs = cStruct!.pointee.xtrans_abs
    }
}
