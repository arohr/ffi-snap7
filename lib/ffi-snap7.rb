require 'rubygems'
require 'ffi'

module Snap7
  extend FFI::Library
  ffi_lib 'libsnap7.so'

  # S7Object
  typedef :pointer, :s7obj

  # parameter numbers
  P_u16_LocalPort       =  1
  P_u16_RemotePort      =  2
  P_i32_PingTimeout     =  3
  P_i32_SendTimeout     =  4
  P_i32_RecvTimeout     =  5
  P_i32_WorkInterval    =  6
  P_u16_SrcRef          =  7
  P_u16_DstRef          =  8
  P_u16_SrcTSap         =  9
  P_i32_PDURequest      = 10
  P_i32_MaxClients      = 11
  P_i32_BSendTimeout    = 12
  P_i32_BRecvTimeout    = 13
  P_u32_RecoveryTime    = 14
  P_u32_KeepAliveTime   = 15
end

require 'ffi-snap7/version'
require 'ffi-snap7/client/client'
require 'ffi-snap7/server/server'
require 'ffi-snap7/data_structures/data_structures'
