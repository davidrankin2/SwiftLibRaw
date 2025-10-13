
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

extension libraw_makernotes_lens_t {
	var string_Lens: String { 
    	return withUnsafePointer(to: self.Lens) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
	var string_body: String { 
    	return withUnsafePointer(to: self.body) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
	var string_LensFeatures_pre: String { 
    	return withUnsafePointer(to: self.LensFeatures_pre) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
	var string_LensFeatures_suf: String { 
    	return withUnsafePointer(to: self.LensFeatures_suf) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
	var string_Teleconverter: String { 
    	return withUnsafePointer(to: self.Teleconverter) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
	var string_Adapter: String { 
    	return withUnsafePointer(to: self.Adapter) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
	var string_Attachment: String { 
    	return withUnsafePointer(to: self.Attachment) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
}

public struct SWL_makernotes_lens {
	public let LensID: UInt64
    public let Lens: String
    public let LensFormat: UInt
    public let LensMount: UInt
	public let CamID: UInt64
    public let CameraFormat: UInt
    public let CameraMount: UInt
    public let body: String
    public let FocalType: Int // (1 is fixed focal, 2 is zoom, rest is unknown)
    public let LensFeatures_pre: String
    public let LensFeatures_suf: String
    public let MinFocal: Float
    public let MaxFocal: Float
    public let MaxAp4MinFocal: Float
    public let MaxAp4MaxFocal: Float
    public let MinAp4MinFocal: Float
    public let MinAp4MaxFocal: Float
    public let MaxAp: Float
    public let MinAp: Float
    public let CurFocal: Float
    public let CurAp: Float
    public let MaxAp4CurFocal: Float
    public let MinAp4CurFocal: Float
    public let MinFocusDistance: Float
    public let FocusRangeIndex: Float
    public let LensFStops: Float
    public let TeleconverterID: UInt64
    public let Teleconverter: String
    public let AdapterID: UInt64
    public let Adapter: String
    public let AttachmentID: UInt64
    public let Attachment: String
    public let FocalUnits: UInt
    public let FocalLengthIn35mmFormat: Float

    init(cStruct: libraw_makernotes_lens_t) {
        self.LensID = cStruct.LensID
        self.Lens = cStruct.string_Lens
        self.LensFormat = UInt(cStruct.LensFormat)
    	self.LensMount = UInt(cStruct.LensMount)
        self.CamID = cStruct.CamID
        self.CameraFormat = UInt(cStruct.CameraFormat)
    	self.CameraMount = UInt(cStruct.CameraMount)
        self.body = cStruct.string_body
    	self.FocalType = Int(cStruct.FocalType)
        self.LensFeatures_pre = cStruct.string_LensFeatures_pre
        self.LensFeatures_suf = cStruct.string_LensFeatures_suf
        self.MinFocal = cStruct.MinFocal ; self.MaxFocal = cStruct.MaxFocal
        self.MaxAp4MinFocal = cStruct.MaxAp4MinFocal
        self.MaxAp4MaxFocal = cStruct.MaxAp4MaxFocal
        self.MinAp4MinFocal = cStruct.MinAp4MinFocal
        self.MinAp4MaxFocal = cStruct.MinAp4MaxFocal
        self.MaxAp = cStruct.MaxAp; self.MinAp = cStruct.MinAp
        self.CurFocal = cStruct.CurFocal; self.CurAp = cStruct.CurAp
        self.MaxAp4CurFocal = cStruct.MaxAp4CurFocal
        self.MinAp4CurFocal = cStruct.MinAp4CurFocal
        self.MinFocusDistance = cStruct.MinFocusDistance
        self.FocusRangeIndex = cStruct.FocusRangeIndex
        self.LensFStops = cStruct.LensFStops
        self.TeleconverterID = cStruct.TeleconverterID
        self.Teleconverter = cStruct.string_Teleconverter
        self.AdapterID = cStruct.AdapterID
        self.Adapter = cStruct.string_Adapter
        self.AttachmentID = cStruct.AttachmentID
        self.Attachment = cStruct.string_Attachment
        self.FocalUnits = UInt(cStruct.FocalUnits)
        self.FocalLengthIn35mmFormat = cStruct.FocalLengthIn35mmFormat
    }
}

public struct SWL_nikonlens {
    public let EffectiveMaxAp: Float
	public let LensIDNumber: UInt // Converted from uchar...
    public let LensFStops: UInt // Converted from uchar...
	public let MCUVersion: UInt // Converted from uchar...
	public let LensType: UInt // Converted from uchar...

    init(cStruct: libraw_nikonlens_t) {
    	self.EffectiveMaxAp = cStruct.EffectiveMaxAp
        self.LensIDNumber = UInt(cStruct.LensIDNumber)
        self.LensFStops = UInt(cStruct.LensFStops)
        self.MCUVersion = UInt(cStruct.MCUVersion)
        self.LensType = UInt(cStruct.LensType)
    }
}

public struct SWL_dnglens {
    public let MinFocal: Float
    public let MaxFocal: Float
    public let MaxAp4MinFocal: Float
    public let MaxAp4MaxFocal: Float

    init(cStruct: libraw_dnglens_t) {
    	self.MinFocal = cStruct.MinFocal
    	self.MaxFocal = cStruct.MaxFocal
    	self.MaxAp4MinFocal = cStruct.MaxAp4MinFocal
    	self.MaxAp4MaxFocal = cStruct.MaxAp4MaxFocal
    }
}

extension libraw_lensinfo_t {
	var string_Lens: String { 
    	return withUnsafePointer(to: self.Lens) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
	var string_LensMake: String { 
    	return withUnsafePointer(to: self.LensMake) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
	var string_LensSerial: String { 
    	return withUnsafePointer(to: self.LensSerial) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
	var string_InternalLensSerial: String { 
    	return withUnsafePointer(to: self.InternalLensSerial) {
    		$0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
    		    String(cString: $0)
    		}
		}
    }
}

public struct SLW_lensinfo {
    public let MinFocal: Float
    public let MaxFocal: Float
    public let MaxAp4MinFocal: Float
    public let MaxAp4MaxFocal: Float
    public let EXIF_MaxAp: Float
    public let LensMake : String
    public let Lens : String
    public let LensSerial : String
    public let InternalLensSerial : String
    public let nikon: SWL_nikonlens
    public let dng: SWL_dnglens
    public let makernotes: SWL_makernotes_lens
  
    init?(cStruct: UnsafeMutablePointer<libraw_lensinfo_t>?) {
    	if (cStruct == nil) {
        	return nil
        }
		self.MinFocal = cStruct!.pointee.MinFocal 
		self.MaxFocal = cStruct!.pointee.MaxFocal 
        self.MaxAp4MinFocal = cStruct!.pointee.MaxAp4MinFocal 
        self.MaxAp4MaxFocal = cStruct!.pointee.MaxAp4MaxFocal 
		self.EXIF_MaxAp = cStruct!.pointee.EXIF_MaxAp 
        self.Lens = cStruct!.pointee.string_Lens
        self.LensMake = cStruct!.pointee.string_LensMake
        self.LensSerial = cStruct!.pointee.string_LensSerial
        self.InternalLensSerial = cStruct!.pointee.string_InternalLensSerial
    	self.nikon = SWL_nikonlens(cStruct: cStruct!.pointee.nikon)
    	self.dng = SWL_dnglens(cStruct: cStruct!.pointee.dng)
    	self.makernotes = SWL_makernotes_lens(cStruct: cStruct!.pointee.makernotes)
    }
}
