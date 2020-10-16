/*
 * Java domain class for entity "Zusatzstoff"
 * Created on 2020-10-04 ( Date ISO 2020-10-04 - Time 20:42:19 )
 * Generated by Telosys Tools Generator ( version 3.1.2 )
 */
package psm.library.dto;

import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Domain class for entity "Zusatzstoff"
 *
 * @author Telosys Tools Generator
 *
 */
public class Zusatzstoff implements Serializable {

    private static final long serialVersionUID = 1L;

    //----------------------------------------------------------------------
    // ENTITY PRIMARY KEY
    //----------------------------------------------------------------------
	@JsonProperty("kennr")
    private String     kennr        ;

    //----------------------------------------------------------------------
    // ENTITY DATA FIELDS
    //----------------------------------------------------------------------
	@JsonProperty("m_row$$")
    private String     mRow$$       ;

	@JsonProperty("genehmigung_am")
    private Date       genehmigungAm ;

	@JsonProperty("mittelname")
    private String     mittelname   ;

	@JsonProperty("antragsteller")
    private String     antragsteller ;

	@JsonProperty("antragsteller_nr")
    private BigDecimal antragstellerNr ;

	@JsonProperty("genehmigungsende")
    private Date       genehmigungsende ;


    //----------------------------------------------------------------------
    // ENTITY LINKS ( RELATIONSHIP )
    //----------------------------------------------------------------------
    private List<ZusatzstoffVertrieb> listOfZusatzstoffVertrieb ;

    //----------------------------------------------------------------------
    // CONSTRUCTOR(S)
    //----------------------------------------------------------------------
    public Zusatzstoff() {
		super();
    }

    //----------------------------------------------------------------------
    // GETTER & SETTER FOR "KEY FIELD(S)"
    //----------------------------------------------------------------------
    public void setKennr( String kennr ) {
        this.kennr = kennr ;
    }
    public String getKennr() {
        return this.kennr;
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

    public void setGenehmigungAm( Date genehmigungAm ) {
        this.genehmigungAm = genehmigungAm ;
    }
    public Date getGenehmigungAm() {
        return this.genehmigungAm;
    }

    public void setMittelname( String mittelname ) {
        this.mittelname = mittelname ;
    }
    public String getMittelname() {
        return this.mittelname;
    }

    public void setAntragsteller( String antragsteller ) {
        this.antragsteller = antragsteller ;
    }
    public String getAntragsteller() {
        return this.antragsteller;
    }

    public void setAntragstellerNr( BigDecimal antragstellerNr ) {
        this.antragstellerNr = antragstellerNr ;
    }
    public BigDecimal getAntragstellerNr() {
        return this.antragstellerNr;
    }

    public void setGenehmigungsende( Date genehmigungsende ) {
        this.genehmigungsende = genehmigungsende ;
    }
    public Date getGenehmigungsende() {
        return this.genehmigungsende;
    }


    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR LINKS
    //----------------------------------------------------------------------
    public void setListOfZusatzstoffVertrieb( List<ZusatzstoffVertrieb> listOfZusatzstoffVertrieb ) {
        this.listOfZusatzstoffVertrieb = listOfZusatzstoffVertrieb;
    }
    public List<ZusatzstoffVertrieb> getListOfZusatzstoffVertrieb() {
        return this.listOfZusatzstoffVertrieb;
    }


    //----------------------------------------------------------------------
    // toString METHOD
    //----------------------------------------------------------------------
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(kennr);
        sb.append("|");
        sb.append(mRow$$);
        sb.append("|");
        sb.append(genehmigungAm);
        sb.append("|");
        sb.append(mittelname);
        sb.append("|");
        sb.append(antragsteller);
        sb.append("|");
        sb.append(antragstellerNr);
        sb.append("|");
        sb.append(genehmigungsende);
        return sb.toString();
    }

}