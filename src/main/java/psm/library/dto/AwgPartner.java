/*
 * Java domain class for entity "AwgPartner"
 * Created on 2020-10-04 ( Date ISO 2020-10-04 - Time 20:42:19 )
 * Generated by Telosys Tools Generator ( version 3.1.2 )
 */
package psm.library.dto;

import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

/**
 * Domain class for entity "AwgPartner"
 *
 * @author Telosys Tools Generator
 *
 */
public class AwgPartner implements Serializable {

    private static final long serialVersionUID = 1L;

    //----------------------------------------------------------------------
    // ENTITY PRIMARY KEY
    //----------------------------------------------------------------------
	@JsonProperty("awg_id")
    private String     awgId        ;
	@JsonProperty("partner_kennr")
    private String     partnerKennr ;

    //----------------------------------------------------------------------
    // ENTITY DATA FIELDS
    //----------------------------------------------------------------------
	@JsonProperty("m_row$$")
    private String     mRow$$       ;

	@JsonProperty("mischung_art")
    private String     mischungArt  ;


    //----------------------------------------------------------------------
    // ENTITY LINKS ( RELATIONSHIP )
    //----------------------------------------------------------------------
    private List<AwgPartnerAufwand> listOfAwgPartnerAufwand ;
    private Mittel     mittel       ;
    private Awg        awg          ;

    //----------------------------------------------------------------------
    // CONSTRUCTOR(S)
    //----------------------------------------------------------------------
    public AwgPartner() {
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


    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR "DATA FIELDS"
    //----------------------------------------------------------------------
    public void setMRow$$( String mRow$$ ) {
        this.mRow$$ = mRow$$ ;
    }
    public String getMRow$$() {
        return this.mRow$$;
    }

    public void setMischungArt( String mischungArt ) {
        this.mischungArt = mischungArt ;
    }
    public String getMischungArt() {
        return this.mischungArt;
    }


    //----------------------------------------------------------------------
    // GETTERS & SETTERS FOR LINKS
    //----------------------------------------------------------------------
    public void setListOfAwgPartnerAufwand( List<AwgPartnerAufwand> listOfAwgPartnerAufwand ) {
        this.listOfAwgPartnerAufwand = listOfAwgPartnerAufwand;
    }
    public List<AwgPartnerAufwand> getListOfAwgPartnerAufwand() {
        return this.listOfAwgPartnerAufwand;
    }

    public void setMittel( Mittel mittel ) {
        this.mittel = mittel;
    }
    public Mittel getMittel() {
        return this.mittel;
    }

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
        sb.append(partnerKennr);
        sb.append("|");
        sb.append(mRow$$);
        sb.append("|");
        sb.append(mischungArt);
        return sb.toString();
    }

}