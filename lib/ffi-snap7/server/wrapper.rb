module Snap7

  # EXPORTSPEC int S7API Srv_ErrorText(int Error, char *Text, int TextLen);
  attach_function :srv_error_text, :Srv_ErrorText, [:int, :pointer, :int], :int

  # EXPORTSPEC S7Object S7API Srv_Create();
  attach_function :srv_create, :Srv_Create, [], :s7obj

  # EXPORTSPEC void S7API Srv_Destroy(S7Object &Server);
  # FIXME crashes MRI
  # attach_function :srv_destroy, :Srv_Destroy, [:s7obj], :void

  # EXPORTSPEC int S7API Srv_GetParam(S7Object Server, int ParamNumber, void *pValue);

  # EXPORTSPEC int S7API Srv_SetParam(S7Object Server, int ParamNumber, void *pValue);

  # EXPORTSPEC int S7API Srv_Start(S7Object Server);
  attach_function :srv_start, :Srv_Start, [:s7obj], :int

  # EXPORTSPEC int S7API Srv_StartTo(S7Object Server, const char *Address);
  # attach_function :srv_start_to, :Srv_StartTo, [:s7obj, :string], :int

  # EXPORTSPEC int S7API Srv_Stop(S7Object Server);
  attach_function :srv_stop, :Srv_Stop, [:s7obj], :int

  # EXPORTSPEC int S7API Srv_RegisterArea(S7Object Server, int AreaCode, word Index, void *pUsrData, int Size);
  attach_function :srv_register_area, :Srv_RegisterArea, [:s7obj, :int, :int16, :pointer, :int], :int

  # EXPORTSPEC int S7API Srv_UnregisterArea(S7Object Server, int AreaCode, word Index);
  # attach_function :srv_unregister_area, :Srv_UnregisterArea, [:s7obj, :int, :int16], :int

  # EXPORTSPEC int S7API Srv_LockArea(S7Object Server, int AreaCode, word Index);

  # EXPORTSPEC int S7API Srv_UnlockArea(S7Object Server, int AreaCode, word Index);


end
