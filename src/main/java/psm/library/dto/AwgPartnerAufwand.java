/*
 * Java domain class for entity "AwgPartnerAufwand"
 * Created on 2020-10-04 ( Date ISO 2020-10-04 - Time 20:42:19 )
 * Generated by Telosys Tools Generator ( version 3.1.2 )
 */
package psm.library.dto;

import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;

/**
 * Domain class for entity "AwgPartnerAufwand"
 *
 * @author Telosys Tools Generator
 *
 */
public class AwgPartnerAufwand implements Serializable {

    private static final long serialVersionUID = 1L;

    //----------------------------------------------------------------------
    // ENTITY PRIMARY KEY
    //----------------------------------------------------------------------
	@JsonProperty("awg_id")
    private String     awgId        ;
	@JsonProperty("partner_kennr")
    private String     partnerKennr ;
	@JsonProperty("aufwandbedingung")
    private String     aufwandbedingung ;

    //----------------------------------------------------------------------
    // ENTITY DATA FIELDS
    //----------------------------------------------------------------------
	@JsonProperty("m_row$$")
    private String     mRow$$       ;

	@JsonProperty("m_aufwand")
    private BigDecimal mAufwand     ;

	@JsonProperty("m_aufwand_einheit")
    private String     mAufwandEinheit ;


    //----------------------------------------------------------------------
    // ENTITY LINKS ( RELATIONSHIP )
    //----------------------------------------------------------------------
    private AwgPartner awgPartner   ;

    //----------------------------------------------------------------------
    // CONSTRUCTOR(S)
    //----------------------------------------------------------------------
    public AwgPartnerAufwand() {
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

    public void setPartnerKennr( String partnerKennr ) {
        this.partnerKennr = partnerKennr ;
    }
    public String getPartnerKennr() {
        return this.partnerKennr;
    }

    public void setAufwandbedingung( String aufwandbedingung ) {
        this.aufwandbedingung = aufwandbedingung ;
    }
    public String getAufwandbedingung() {
        return this.aufwandbedingung;
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


    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR LINKS
    //----------------------------------------------------------------------
    public void setAwgPartner( AwgPartner awgPartner ) {
        this.awgPartner = awgPartner;
    }
    public AwgPartner getAwgPartner() {
        return this.awgPartner;
    }


    //----------------------------------------------------------------------
    // toString METHOD
    //----------------------------------------------------------------------
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(awgId);
        sb.append("|");
        sb.append(partnerKennr);
        sb.append("|");
        sb.append(aufwandbedingung);
        sb.append("|");
        sb.append(mRow$$);
        sb.append("|");
        sb.append(mAufwand);
        sb.append("|");
        sb.append(mAufwandEinheit);
        return sb.toString();
    }

}
