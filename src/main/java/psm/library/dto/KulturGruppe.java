/*
 * Java domain class for entity "KulturGruppe"
 * Created on 2020-10-04 ( Date ISO 2020-10-04 - Time 20:42:19 )
 * Generated by Telosys Tools Generator ( version 3.1.2 )
 */
package psm.library.dto;

import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonProperty;


/**
 * Domain class for entity "KulturGruppe"
 *
 * @author Telosys Tools Generator
 *
 */
public class KulturGruppe implements Serializable {

    private static final long serialVersionUID = 1L;

    //----------------------------------------------------------------------
    // ENTITY PRIMARY KEY
    //----------------------------------------------------------------------
	@JsonProperty("kultur_gruppe")
    private String     kulturGruppe ;
	@JsonProperty("kultur")
    private String     kultur       ;

    //----------------------------------------------------------------------
    // ENTITY DATA FIELDS
    //----------------------------------------------------------------------
	@JsonProperty("m_row$$")
    private String     mRow$$       ;


    //----------------------------------------------------------------------
    // ENTITY LINKS ( RELATIONSHIP )
    //----------------------------------------------------------------------

    //----------------------------------------------------------------------
    // CONSTRUCTOR(S)
    //----------------------------------------------------------------------
    public KulturGruppe() {
		super();
    }

    //----------------------------------------------------------------------
    // GETTER & SETTER FOR "KEY FIELD(S)"
    //----------------------------------------------------------------------
    public void setKulturGruppe( String kulturGruppe ) {
        this.kulturGruppe = kulturGruppe ;
    }
    public String getKulturGruppe() {
        return this.kulturGruppe;
    }

    public void setKultur( String kultur ) {
        this.kultur = kultur ;
    }
    public String getKultur() {
        return this.kultur;
    }


    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR "DATA FIELDS"
    //----------------------------------------------------------------------
    public void setMRow$$( String mRow$$ ) {
        this.mRow$$ = mRow$$ ;
    }
    public String getMRow$$() {
        return this.mRow$$;
    }


    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR LINKS
    //----------------------------------------------------------------------

    //----------------------------------------------------------------------
    // toString METHOD
    //----------------------------------------------------------------------
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(kulturGruppe);
        sb.append("|");
        sb.append(kultur);
        sb.append("|");
        sb.append(mRow$$);
        return sb.toString();
    }

}
