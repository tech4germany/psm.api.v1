/*************************************************************************************
  Aktiviert ORDS für das betroffene Schema.
*************************************************************************************/
BEGIN
ORDS.ENABLE_SCHEMA(
   p_schema                => 'psm',
   p_url_mapping_type      => 'BASE_PATH',
   p_url_mapping_pattern   => 'psm',
   p_auto_rest_auth        => FALSE);
END;
