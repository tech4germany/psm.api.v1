/*
 * Java domain class for entity "AwgAufwand"
 * Created on 2020-10-04 ( Date ISO 2020-10-04 - Time 20:42:19 )
 * Generated by Telosys Tools Generator ( version 3.1.2 )
 */
package psm.library.dto;

import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;

/**
 * Domain class for entity "AwgAufwand"
 *
 * @author Telosys Tools Generator
 *
 */
public class AwgAufwand implements Serializable {

    private static final long serialVersionUID = 1L;

    //----------------------------------------------------------------------
    // ENTITY PRIMARY KEY
    //----------------------------------------------------------------------
	@JsonProperty("awg_id")
    private String     awgId        ;
	@JsonProperty("aufwandbedingung")
    private String     aufwandbedingung ;
	@JsonProperty("sortier_nr")
    private BigDecimal sortierNr    ;

    //----------------------------------------------------------------------
    // ENTITY DATA FIELDS
    //----------------------------------------------------------------------
	@JsonProperty("m_row$$")
    private String     mRow$$       ;

	@JsonProperty("m_aufwand")
    private BigDecimal mAufwand     ;

	@JsonProperty("m_aufwand_einheit")
    private String     mAufwandEinheit ;

	@JsonProperty("w_aufwand_von")
    private BigDecimal wAufwandVon  ;

	@JsonProperty("w_aufwand_bis")
    private BigDecimal wAufwandBis  ;

	@JsonProperty("w_aufwand_einheit")
    private String     wAufwandEinheit ;


    //----------------------------------------------------------------------
    // ENTITY LINKS ( RELATIONSHIP )
    //----------------------------------------------------------------------
    private Awg        awg          ;

    //----------------------------------------------------------------------
    // CONSTRUCTOR(S)
    //----------------------------------------------------------------------
    public AwgAufwand() {
		super();
    }

    //----------------------------------------------------------------------
    // GETTER & SETTER FOR "KEY FIELD(S)"
    //----------------------------------------------------------------------
    public void setAwgId( String awgId ) {
        this.awgId = awgId ;
    }
    public String getAwgId() {
        return this.awgId;
    }

    public void setAufwandbedingung( String aufwandbedingung ) {
        this.aufwandbedingung = aufwandbedingung ;
    }
    public String getAufwandbedingung() {
        return this.aufwandbedingung;
    }

    public void setSortierNr( BigDecimal sortierNr ) {
        this.sortierNr = sortierNr ;
    }
    public BigDecimal getSortierNr() {
        return this.sortierNr;
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

    public void setMAufwand( BigDecimal mAufwand ) {
        this.mAufwand = mAufwand ;
    }
    public BigDecimal getMAufwand() {
        return this.mAufwand;
    }

    public void setMAufwandEinheit( String mAufwandEinheit ) {
        this.mAufwandEinheit = mAufwandEinheit ;
    }
    public String getMAufwandEinheit() {
        return this.mAufwandEinheit;
    }

    public void setWAufwandVon( BigDecimal wAufwandVon ) {
        this.wAufwandVon = wAufwandVon ;
    }
    public BigDecimal getWAufwandVon() {
        return this.wAufwandVon;
    }

    public void setWAufwandBis( BigDecimal wAufwandBis ) {
        this.wAufwandBis = wAufwandBis ;
    }
    public BigDecimal getWAufwandBis() {
        return this.wAufwandBis;
    }

    public void setWAufwandEinheit( String wAufwandEinheit ) {
        this.wAufwandEinheit = wAufwandEinheit ;
    }
    public String getWAufwandEinheit() {
        return this.wAufwandEinheit;
    }


    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR LINKS
    //----------------------------------------------------------------------
    public void setAwg( Awg awg ) {
        this.awg = awg;
    }
    public Awg getAwg() {
        return this.awg;
    }


    //----------------------------------------------------------------------
    // toString METHOD
    //----------------------------------------------------------------------
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(awgId);
        sb.append("|");
        sb.append(aufwandbedingung);
        sb.append("|");
        sb.append(sortierNr);
        sb.append("|");
        sb.append(mRow$$);
        sb.append("|");
        sb.append(mAufwand);
        sb.append("|");
        sb.append(mAufwandEinheit);
        sb.append("|");
        sb.append(wAufwandVon);
        sb.append("|");
        sb.append(wAufwandBis);
        sb.append("|");
        sb.append(wAufwandEinheit);
        return sb.toString();
    }

}
