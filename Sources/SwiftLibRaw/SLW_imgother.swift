
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

public struct SWL_gpsinfo {
    public let latitude: (Float, Float, Float)
	public let longitude: (Float, Float, Float)
	public let gpstimestamp: (Float, Float, Float)
	public let altitude: Float
    public let altref: Character?
    public let latref: Character?
    public let longref: Character?
    public let gpsstatus: Character?
    public let gpsparsed: Bool

    init(cStruct: libraw_gps_info_t) {
    	self.latitude = cStruct.latitude
        self.longitude = cStruct.longitude
    	self.gpstimestamp = cStruct.gpstimestamp
    	self.altitude = cStruct.altitude
        // These are Optionals because they can be empty/unset, and 0.
        self.altref = (cStruct.altref == 0 ? nil : Character(UnicodeScalar(Int(cStruct.altref))!) )
        self.latref = (cStruct.latref == 0 ? nil : Character(UnicodeScalar(Int(cStruct.latref))!) )
        self.longref = (cStruct.latref == 0 ? nil : Character(UnicodeScalar(Int(cStruct.longref))!) )
        self.gpsstatus = (cStruct.latref == 0 ? nil : Character(UnicodeScalar(Int(cStruct.gpsstatus))!) )
        // This is a converted boolean.
        self.gpsparsed = (cStruct.gpsparsed != 0)
    }
}

extension libraw_imgother_t {
    var string_desc: String {
        return withUnsafePointer(to: self.desc) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
    }
    var string_artist: String {
        return withUnsafePointer(to: self.artist) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                String(cString: $0)
            }
        }
    }
}

public struct SLW_imgother {
    public let iso_speed: Float
    public let shutter: Float
    public let aperture: Float
    public let focal_len: Float
    public let shot_order: UInt
    public let gpsdata: Any
    public let analogbalance: Any
    public let desc: String
    public let artist: String
   
    public let parsed_gps: SWL_gpsinfo
  
    init?(cStruct: UnsafeMutablePointer<libraw_imgother_t>?) {
    	if (cStruct == nil) {
        	return nil
        }
		self.iso_speed = cStruct!.pointee.iso_speed 
		self.shutter = cStruct!.pointee.shutter 
		self.aperture = cStruct!.pointee.aperture 
		self.focal_len = cStruct!.pointee.focal_len 
		self.shot_order = UInt(cStruct!.pointee.shot_order) 
    	self.gpsdata = cStruct!.pointee.gpsdata 
		self.analogbalance = cStruct!.pointee.analogbalance
        self.desc = cStruct!.pointee.string_desc
        self.artist = cStruct!.pointee.string_artist
        self.parsed_gps = SWL_gpsinfo(cStruct: cStruct!.pointee.parsed_gps)
    }
}
