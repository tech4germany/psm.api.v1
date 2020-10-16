/*
 * Java domain class for entity "Stand"
 * Created on 2020-10-04 ( Date ISO 2020-10-04 - Time 20:42:19 )
 * Generated by Telosys Tools Generator ( version 3.1.2 )
 */
package psm.library.dto;

import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

/**
 * Domain class for entity "Stand"
 *
 * @author Telosys Tools Generator
 *
 */
public class Stand implements Serializable {

    private static final long serialVersionUID = 1L;

    //----------------------------------------------------------------------
    // ENTITY PRIMARY KEY
    //----------------------------------------------------------------------

    //----------------------------------------------------------------------
    // ENTITY DATA FIELDS
    //----------------------------------------------------------------------
	@JsonProperty("m_row$$")
    private String     mRow$$       ;

	@JsonProperty("datum")
    private Date       datum        ;


    //----------------------------------------------------------------------
    // ENTITY LINKS ( RELATIONSHIP )
    //----------------------------------------------------------------------

    //----------------------------------------------------------------------
    // CONSTRUCTOR(S)
    //----------------------------------------------------------------------
    public Stand() {
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

    public void setDatum( Date datum ) {
        this.datum = datum ;
    }
    public Date getDatum() {
        return this.datum;
    }


    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR LINKS
    //----------------------------------------------------------------------

    //----------------------------------------------------------------------
    // toString METHOD
    //----------------------------------------------------------------------
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(mRow$$);
        sb.append("|");
        sb.append(datum);
        return sb.toString();
    }

}
