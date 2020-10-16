/*************************************************************************************
  Deaktiviert bzw. entfernt ORDS für das betroffene Schema.
*************************************************************************************/
BEGIN
    ORDS.ENABLE_SCHEMA(p_enabled => FALSE);
    ORDS.drop_rest_for_schema();
    commit;
END;

