module Snap7

  # EXPORTSPEC S7Object S7API Cli_Create();
  attach_function :cli_create, :Cli_Create, [], :s7obj

  # EXPORTSPEC void S7API Cli_Destroy(S7Object &Client);
  # FIXME crashes MRI
  # attach_function :cli_destroy, :Cli_Destroy, [:s7obj], :void

  # EXPORTSPEC int S7API Cli_ConnectTo(S7Object Client, const char *Address, int Rack, int Slot);
  attach_function :cli_connect_to, :Cli_ConnectTo, [:s7obj, :string, :int, :int], :int

  # EXPORTSPEC int S7API Cli_Disconnect(S7Object Client);
  attach_function :cli_disconnect, :Cli_Disconnect, [:s7obj], :int

  # EXPORTSPEC int S7API Cli_DBRead(S7Object Client, int DBNumber, int Start, int Size, void *pUsrData);
  attach_function :cli_db_read, :Cli_DBRead, [:s7obj, :int, :int, :int, :pointer], :int

  # EXPORTSPEC int S7API Cli_DBWrite(S7Object Client, int DBNumber, int Start, int Size, void *pUsrData);
  attach_function :cli_db_write, :Cli_DBWrite, [:s7obj, :int, :int, :int, :pointer], :int

  # EXPORTSPEC int S7API Cli_ErrorText(int Error, char *Text, int TextLen);
  attach_function :cli_error_text, :Cli_ErrorText, [:int, :pointer, :int], :int


end