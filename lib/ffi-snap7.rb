require 'rubygems'
require 'ffi'

module Snap7
  extend FFI::Library
  ffi_lib 'libsnap7.so'

  # S7Object
  typedef :pointer, :s7obj
end

require 'lib/ffi-snap7/version'
require 'lib/ffi-snap7/client/client'
require 'lib/ffi-snap7/server/server'
