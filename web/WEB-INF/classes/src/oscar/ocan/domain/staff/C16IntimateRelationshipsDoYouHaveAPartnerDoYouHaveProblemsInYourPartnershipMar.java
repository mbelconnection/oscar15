//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vhudson-jaxb-ri-2.1-793 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2009.05.24 at 10:52:14 PM EDT 
//


package oscar.ocan.domain.staff;

import java.math.BigInteger;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{}C1__Does_this_person_have_any_difficulty_in_finding_a_partner_or_in_maintaining_a_close_relation"/>
 *         &lt;element ref="{}C2__How_much_help_with_forming_and_maintaining_close_relationships_does_the_person_receive_from_"/>
 *         &lt;element ref="{}C3a__How_much_help_with_forming_and_maintaining_close_relationships_does_the_person_receive_from"/>
 *         &lt;element ref="{}C3b__How_much_help_with_forming_and_maintaining_close_relationships_does_the_person_need_from_lo"/>
 *         &lt;element ref="{}CComments_"/>
 *         &lt;element ref="{}CActions_"/>
 *         &lt;element ref="{}CBy_whom_"/>
 *         &lt;element ref="{}CReview_date_"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "c1DoesThisPersonHaveAnyDifficultyInFindingAPartnerOrInMaintainingACloseRelation",
    "c2HowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom",
    "c3AHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom",
    "c3BHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonNeedFromLo",
    "cComments",
    "cActions",
    "cByWhom",
    "cReviewDate"
})
@XmlRootElement(name = "C16__Intimate_relationships__Do_you_have_a_partner__Do_you_have_problems_in_your_partnership_mar")
public class C16IntimateRelationshipsDoYouHaveAPartnerDoYouHaveProblemsInYourPartnershipMar {

    @XmlElement(name = "C1__Does_this_person_have_any_difficulty_in_finding_a_partner_or_in_maintaining_a_close_relation", required = true)
    protected BigInteger c1DoesThisPersonHaveAnyDifficultyInFindingAPartnerOrInMaintainingACloseRelation;
    @XmlElement(name = "C2__How_much_help_with_forming_and_maintaining_close_relationships_does_the_person_receive_from_", required = true)
    protected BigInteger c2HowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom;
    @XmlElement(name = "C3a__How_much_help_with_forming_and_maintaining_close_relationships_does_the_person_receive_from", required = true)
    protected BigInteger c3AHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom;
    @XmlElement(name = "C3b__How_much_help_with_forming_and_maintaining_close_relationships_does_the_person_need_from_lo", required = true)
    protected BigInteger c3BHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonNeedFromLo;
    @XmlElement(name = "CComments_", required = true)
    protected CComments cComments;
    @XmlElement(name = "CActions_", required = true)
    protected String cActions;
    @XmlElement(name = "CBy_whom_", required = true)
    protected String cByWhom;
    @XmlElement(name = "CReview_date_", required = true)
    protected String cReviewDate;

    /**
     * Gets the value of the c1DoesThisPersonHaveAnyDifficultyInFindingAPartnerOrInMaintainingACloseRelation property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getC1DoesThisPersonHaveAnyDifficultyInFindingAPartnerOrInMaintainingACloseRelation() {
        return c1DoesThisPersonHaveAnyDifficultyInFindingAPartnerOrInMaintainingACloseRelation;
    }

    /**
     * Sets the value of the c1DoesThisPersonHaveAnyDifficultyInFindingAPartnerOrInMaintainingACloseRelation property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setC1DoesThisPersonHaveAnyDifficultyInFindingAPartnerOrInMaintainingACloseRelation(BigInteger value) {
        this.c1DoesThisPersonHaveAnyDifficultyInFindingAPartnerOrInMaintainingACloseRelation = value;
    }

    /**
     * Gets the value of the c2HowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getC2HowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom() {
        return c2HowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom;
    }

    /**
     * Sets the value of the c2HowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setC2HowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom(BigInteger value) {
        this.c2HowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom = value;
    }

    /**
     * Gets the value of the c3AHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getC3AHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom() {
        return c3AHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom;
    }

    /**
     * Sets the value of the c3AHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setC3AHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom(BigInteger value) {
        this.c3AHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonReceiveFrom = value;
    }

    /**
     * Gets the value of the c3BHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonNeedFromLo property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getC3BHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonNeedFromLo() {
        return c3BHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonNeedFromLo;
    }

    /**
     * Sets the value of the c3BHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonNeedFromLo property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setC3BHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonNeedFromLo(BigInteger value) {
        this.c3BHowMuchHelpWithFormingAndMaintainingCloseRelationshipsDoesThePersonNeedFromLo = value;
    }

    /**
     * Gets the value of the cComments property.
     * 
     * @return
     *     possible object is
     *     {@link CComments }
     *     
     */
    public CComments getCComments() {
        return cComments;
    }

    /**
     * Sets the value of the cComments property.
     * 
     * @param value
     *     allowed object is
     *     {@link CComments }
     *     
     */
    public void setCComments(CComments value) {
        this.cComments = value;
    }

    /**
     * Gets the value of the cActions property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCActions() {
        return cActions;
    }

    /**
     * Sets the value of the cActions property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCActions(String value) {
        this.cActions = value;
    }

    /**
     * Gets the value of the cByWhom property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCByWhom() {
        return cByWhom;
    }

    /**
     * Sets the value of the cByWhom property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCByWhom(String value) {
        this.cByWhom = value;
    }

    /**
     * Gets the value of the cReviewDate property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCReviewDate() {
        return cReviewDate;
    }

    /**
     * Sets the value of the cReviewDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCReviewDate(String value) {
        this.cReviewDate = value;
    }

}