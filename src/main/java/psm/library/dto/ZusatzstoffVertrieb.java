/*
 * Java domain class for entity "ZusatzstoffVertrieb"
 * Created on 2020-10-04 ( Date ISO 2020-10-04 - Time 20:42:19 )
 * Generated by Telosys Tools Generator ( version 3.1.2 )
 */
package psm.library.dto;

import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;

/**
 * Domain class for entity "ZusatzstoffVertrieb"
 *
 * @author Telosys Tools Generator
 *
 */
public class ZusatzstoffVertrieb implements Serializable {

    private static final long serialVersionUID = 1L;

    //----------------------------------------------------------------------
    // ENTITY PRIMARY KEY
    //----------------------------------------------------------------------

    //----------------------------------------------------------------------
    // ENTITY DATA FIELDS
    //----------------------------------------------------------------------
	@JsonProperty("m_row$$")
    private String     mRow$$       ;

	@JsonProperty("vertriebsfirma")
    private String     vertriebsfirma ;

	@JsonProperty("vertriebsfirma_nr")
    private BigDecimal vertriebsfirmaNr ;

	// Attribute "kennr" is a link
	@JsonProperty("kennr")
	private String     kennr        ;

    //----------------------------------------------------------------------
    // ENTITY LINKS ( RELATIONSHIP )
    //----------------------------------------------------------------------
    private Zusatzstoff zusatzstoff  ;

    //----------------------------------------------------------------------
    // CONSTRUCTOR(S)
    //----------------------------------------------------------------------
    public ZusatzstoffVertrieb() {
		super();
    }

    //----------------------------------------------------------------------
    // GETTER & SETTER FOR "KEY FIELD(S)"
    //----------------------------------------------------------------------

    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR "DATA FIELDS"
    //----------------------------------------------------------------------
    public void setMRow$$( String mRow$$ ) {
        this.mRow$$ = mRow$$ ;
    }
    public String getMRow$$() {
        return this.mRow$$;
    }

    public void setVertriebsfirma( String vertriebsfirma ) {
        this.vertriebsfirma = vertriebsfirma ;
    }
    public String getVertriebsfirma() {
        return this.vertriebsfirma;
    }

    public void setVertriebsfirmaNr( BigDecimal vertriebsfirmaNr ) {
        this.vertriebsfirmaNr = vertriebsfirmaNr ;
    }
    public BigDecimal getVertriebsfirmaNr() {
        return this.vertriebsfirmaNr;
    }


    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR LINKS
    //----------------------------------------------------------------------
    public void setZusatzstoff( Zusatzstoff zusatzstoff ) {
        this.zusatzstoff = zusatzstoff;
    }
    public Zusatzstoff getZusatzstoff() {
        return this.zusatzstoff;
    }


    //----------------------------------------------------------------------
    // toString METHOD
    //----------------------------------------------------------------------
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(mRow$$);
        sb.append("|");
        sb.append(vertriebsfirma);
        sb.append("|");
        sb.append(vertriebsfirmaNr);
        return sb.toString();
    }

}
