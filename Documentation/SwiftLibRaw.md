# SwiftLibRaw

## License

Copyright © 2025 David W. Rankin Jr.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files
(the "Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Distribution

The SwiftLibRaw package in source form may be distributed under the license
detailed above (hereafter, the "MIT License").

In its current form, libSwiftLibRaw.dylib includes both code under the MIT
license as above, and LibRaw code under the LGPL and CDDL licenses, as
specified in the LibRaw package. Any distribution of the dylib file with an
executable must obey the requirements of the LGPL and/or CDDL licenses as
specified by the LibRaw package.

## History and Focus

We started out building SwiftLibRaw to work around a bug in Apple's CR3
Metadata reader on MacOS. The development effort for this library will be
focused around reading information for some time.

Also, the focus will be to present Swift focused objects, rather than just
pass through the C objects directly. This will result in more memory used,
but you should be able to use the data (strings, Data objects, etc.) even
after the SwiftLibRaw object is destroyed.

## Supported LibRaw releases

The main branch of this code is currently supported with `0.21.4`, but
should work with any code ABI-compatible with `0.21.x`. At this moment,
we require installation of the Homebrew cask `libraw` to provide the `libraw_r`
static and dynamic libraries.

## Thread-safe Status

SwiftLibRaw compiles the source code without the LIBRAW_NOTHREADS option.
This should make code equivalent to the `libraw_r` thread-safe compilation.

The SwiftLibRaw object itself is protected by a `OSAllocatedUnfairLock`
lock used for all calls after the init process succeeds. 

User callbacks are one area where a single thread could attempt to
call a SwiftLibRaw object while already inside the `OSAllocatedUnfairLock`.
SwiftLibRaw currently does not support external user callbacks, but when
they do exist, callback code paths must not attempt to call the object
again, at the risk of a deadlock or process crash.

SLW_* objects are read-only once created, and are thread-safe by nature.

## Structs and Objects:

Numerics are generally converted to UInt or Int, rather than 8, 16, or 32 bit
integers or unsigned integers. Character strings are converted to Strings. 
Data buffers are converted from char * or void * memory buffers to Data
objects. Arrays are usually left as unconverted tuples.

### SwiftLibRaw

```
    public var metadata: Dictionary<Int32, Any>

    public init?(fileUrl: URL, options:Dictionary<String, Any>? = nil)
    public func get_imgother() -> SLW_imgother? {}
    public func get_lensinfo() -> SLW_lensinfo? {}
    public func get_iparams() -> SLW_iparams? {}
    public func get_cam_mul(index: Int32) -> Float {}
    public func get_pre_mul(index: Int32) -> Float {}
    public func get_rgb_cam(index1: Int32, index2: Int32) -> Float {}
    public func get_raw_height() -> Int32 {}
    public func get_raw_width() -> Int32 {}
    public func get_iheight() -> Int32 {}
    public func get_iwidth() -> Int32 {}
    public func get_metadata() -> Dictionary<Int32, Any> {}
    public func get_metadata(tag: Int32) -> Any? {}
```

#### init and Options

The primary, non-optional option for the initator is `fileURL`, a URL object
to the file to read. The object initiator will run the following process

* `libraw_init`

* Set up an exifparser handler (more on this in a moment).

* run `libraw_open_file` to open the file.

* Unpack the file with `libraw_unpack`. This populates the various information
  structs in the object.

Optional settings are in `options`. Currently, two options are recognized:

* `No_Dataerr_Callback` with any value other than nil: If this is set, this
  will give libraw_init the option `1`, equivalent to
  `LIBRAW_OPTIONS_NO_DATAERR_CALLBACK`. 

* `library_exifparser`. When this is any value but nil, SwiftLibRaw.metadata
  will be populated with raw metadata from the file. This dictionary is a 
  Dictionary<Int32, Any>, with the key as the tag as presented under
  libraw_callbacks_t in
  [the documentation](https://www.libraw.org/docs/API-datastruct-eng.html#libraw_callbacks_t).

  Access to this metadata is detailed below.

  * Byte and Undefined data is returned as a Data object.

  * ASCII and UTF-8 data (even single characters) are returned as a String.

  * Single integers are returned as the type (UInt16, UInt32, or Int32).
    Multiples are returned as tuples of integers.

  * Single Rationals and Signed Rationals are returned as
  	a (Double, Int32/UInt32, Int32/UInt32) tuple. Multiple values (like
    GPS co-ordinates) are a tuple of (Double Array, Int/UInt Array, Int/UInt
    Array)

### SwiftLibRaw get_metadata

The metadata generated if library_exifparser is selected is returned by
get_metadata. If no argument is given, the entire dictionary is returned.
If a specific key is requested, that key or a nil is requested.

If library_exifparser was not selected, then get_metadata will return
an empty dictionary, or nil if a specific key is requested.

### SLW_iparams

After creation of the SwiftLibRaw object, a SWL_iparams object can be
retrieved by running:

`iparams = librawfile.get_iparams()`

The data within is functionally identical to the origiginal `libraw_iparams_t`.
Original LibRaw documentation for `libraw_iparams_t` is 
[here](https://www.libraw.org/docs/API-datastruct-eng.html#libraw_iparams_t).

SWL_iparams is:

```
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
```

Adjustments specific for SWL_iparams:

* The C character buffer `guard` has been renamed `guard_string` due to
  the conflict with the Swift keyword guard.

* xmpdata is converted to a Data object.

* xtrans and xtrans_abs are a 5 object tuple, each 5 CChar/UInt8 objects.

### SLW_imgother ( `libraw_imgother_t` ) 

After creation of the SwiftLibRaw object, a SLW_imgother object can be
retrieved by running:

`imgother = librawfile.get_imgother()`

The data within is functionally identical to the origiginal `libraw_imgother_t`.
The original LibRaw documentation is
[here](https://www.libraw.org/docs/API-datastruct-eng.html#libraw_imgother_t).

```
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
```

Specific adjustments for SLW_imgother:

* gpsdata is a 32 item tuple of Unsigned Int32s. No conversion has occured.

* Analogbalance is a 4 Float tuple.

SWL_gpsinfo:

```
    public let latitude: (Float, Float, Float)
    public let longitude: (Float, Float, Float)
    public let gpstimestamp: (Float, Float, Float)
    public let altitude: Float
    public let altref: Character?
    public let latref: Character?
    public let longref: Character?
    public let gpsstatus: Character?
    public let gpsparsed: Bool
```

* gpsparsed is converted to a Bool.

* In the C interface, altref, latref, longref, and gpsstatus could have byte 0
  as the empty
  status. For these Character? characters, they return nil instead of 0.


### SLW_lensinfo (`libraw_lensinfo_t`) 

After creation of the SwiftLibRaw object, a SLW_lensinfo object can be
retrieved by running:

`imgother = librawfile.get_lensinfo()`

The data within is functionally identical to the origiginal `libraw_lensinfo_t`.
Original LibRaw documentation 
[here](https://www.libraw.org/docs/API-datastruct-eng.html#libraw_lensinfo_t).

```
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
```

`SWL_nikonlens`: (`libraw_nikonlens_t`)

```
    public let EffectiveMaxAp: Float
    public let LensIDNumber: UInt // Converted from uchar...
    public let LensFStops: UInt // Converted from uchar...
    public let MCUVersion: UInt // Converted from uchar...
    public let LensType: UInt // Converted from uchar...
```

`SWL_dnglens`: (`libraw_dnglens_t`)

```
    public let MinFocal: Float
    public let MaxFocal: Float
    public let MaxAp4MinFocal: Float
    public let MaxAp4MaxFocal: Float
```

`SWL_makernotes_lens`: (`libraw_makernotes_lens_t`) 

```
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
```

For `SWL_makernotes_lens`, some values that are explicitly 64 bit are left
UInt64, to prevent overflow on 32 bit platforms.

