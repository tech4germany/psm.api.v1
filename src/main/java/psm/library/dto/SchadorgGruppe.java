/*
 * Java domain class for entity "SchadorgGruppe"
 * Created on 2020-10-04 ( Date ISO 2020-10-04 - Time 20:42:19 )
 * Generated by Telosys Tools Generator ( version 3.1.2 )
 */
package psm.library.dto;

import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonProperty;


/**
 * Domain class for entity "SchadorgGruppe"
 *
 * @author Telosys Tools Generator
 *
 */
public class SchadorgGruppe implements Serializable {

    private static final long serialVersionUID = 1L;

    //----------------------------------------------------------------------
    // ENTITY PRIMARY KEY
    //----------------------------------------------------------------------
	@JsonProperty("schadorg")
    private String     schadorg     ;
	@JsonProperty("schadorg_gruppe")
    private String     schadorgGruppe ;

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
    public SchadorgGruppe() {
		super();
    }

    //----------------------------------------------------------------------
    // GETTER & SETTER FOR "KEY FIELD(S)"
    //----------------------------------------------------------------------
    public void setSchadorg( String schadorg ) {
        this.schadorg = schadorg ;
    }
    public String getSchadorg() {
        return this.schadorg;
    }

    public void setSchadorgGruppe( String schadorgGruppe ) {
        this.schadorgGruppe = schadorgGruppe ;
    }
    public String getSchadorgGruppe() {
        return this.schadorgGruppe;
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
        sb.append(schadorg);
        sb.append("|");
        sb.append(schadorgGruppe);
        sb.append("|");
        sb.append(mRow$$);
        return sb.toString();
    }

}
