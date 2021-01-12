function cvi_emsg_log_put_message.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(I_MESSAGE) TYPE  BAPIRET2
*"----------------------------------------------------------------------

  data:
    lv_messagetype type emsg_mesg.

  concatenate i_message-type i_message-number '(' i_message-id ')' into lv_messagetype.
  mac_msg_put_we lv_messagetype i_message-message_v1 i_message-message_v2 i_message-message_v3 i_message-message_v4.

endfunction.
