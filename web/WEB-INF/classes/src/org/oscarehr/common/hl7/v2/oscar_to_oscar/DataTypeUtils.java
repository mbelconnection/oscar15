package org.oscarehr.common.hl7.v2.oscar_to_oscar;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.oscarehr.common.Gender;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.Provider;
import org.oscarehr.util.MiscUtils;

import ca.uhn.hl7v2.HL7Exception;
import ca.uhn.hl7v2.model.DataTypeException;
import ca.uhn.hl7v2.model.v25.datatype.CX;
import ca.uhn.hl7v2.model.v25.datatype.DT;
import ca.uhn.hl7v2.model.v25.datatype.DTM;
import ca.uhn.hl7v2.model.v25.datatype.FT;
import ca.uhn.hl7v2.model.v25.datatype.XAD;
import ca.uhn.hl7v2.model.v25.datatype.XCN;
import ca.uhn.hl7v2.model.v25.datatype.XPN;
import ca.uhn.hl7v2.model.v25.datatype.XTN;
import ca.uhn.hl7v2.model.v25.segment.MSH;
import ca.uhn.hl7v2.model.v25.segment.NTE;
import ca.uhn.hl7v2.model.v25.segment.PID;
import ca.uhn.hl7v2.model.v25.segment.ROL;
import ca.uhn.hl7v2.model.v25.segment.SFT;

public final class DataTypeUtils {
	private static final Logger logger = MiscUtils.getLogger();
	public static final String HEALTH_NUMBER = "HEALTH_NUMBER";
	public static final String CHART_NUMBER = "CHART_NUMBER";
	public static final String HL7_VERSION_ID = "2.5";
	public static final int NTE_COMMENT_MAX_SIZE = 65536;
	public static final String ACTION_ROLE_SENDER = "SENDER";
	public static final String ACTION_ROLE_RECEIVER = "RECEIVER";
	private static final Base64 base64 = new Base64();

	/**
	 * Don't access this formatter directly, use the getAsFormattedString method, it provides synchronisation
	 */
	private static final SimpleDateFormat dateTimeFormatter = new SimpleDateFormat("yyyyMMddHHmmss");

	private DataTypeUtils() {
		// not meant to be instantiated by anyone, it's a util class
	}

	public static String encodeToBase64String(byte[] b) throws UnsupportedEncodingException {
		return (new String(base64.encode(b), MiscUtils.ENCODING));
	}

	public static byte[] decodeBase64(String s) throws UnsupportedEncodingException {
		return (base64.decode(s.getBytes(MiscUtils.ENCODING)));
	}

	public static String encodeToBase64String(String s) throws UnsupportedEncodingException {
		return (new String(base64.encode(s.getBytes(MiscUtils.ENCODING)), MiscUtils.ENCODING));
	}

	public static String decodeBase64StoString(String s) throws UnsupportedEncodingException {
		return (new String(base64.decode(s.getBytes(MiscUtils.ENCODING)), MiscUtils.ENCODING));
	}

	public static String getAsHl7FormattedString(Date date) {
		synchronized (dateTimeFormatter) {
			return (dateTimeFormatter.format(date));
		}
	}

	private static GregorianCalendar getCalendarFromDT(DT dt) throws DataTypeException {

		// hl7/hapi returns 0 for no date
		if (dt.getYear() == 0 || dt.getMonth() == 0 || dt.getDay() == 0) return (null);

		GregorianCalendar cal = new GregorianCalendar();
		// zero out fields we don't use
		cal.setTimeInMillis(0);
		cal.set(GregorianCalendar.YEAR, dt.getYear());
		cal.set(GregorianCalendar.MONTH, dt.getMonth() - 1);
		cal.set(GregorianCalendar.DAY_OF_MONTH, dt.getDay());

		// force materialisation of values
		cal.getTimeInMillis();

		return (cal);
	}

	public static GregorianCalendar getCalendarFromDTM(DTM dtm) throws DataTypeException {

		// hl7/hapi returns 0 for no date
		if (dtm.getYear() == 0 || dtm.getMonth() == 0 || dtm.getDay() == 0) return (null);

		GregorianCalendar cal = new GregorianCalendar();
		// zero out fields we don't use
		cal.setTimeInMillis(0);
		cal.set(GregorianCalendar.YEAR, dtm.getYear());
		cal.set(GregorianCalendar.MONTH, dtm.getMonth() - 1);
		cal.set(GregorianCalendar.DAY_OF_MONTH, dtm.getDay());
		cal.set(GregorianCalendar.HOUR_OF_DAY, dtm.getHour());
		cal.set(GregorianCalendar.MINUTE, dtm.getMinute());
		cal.set(GregorianCalendar.SECOND, dtm.getSecond());

		// force materialisation of values
		cal.getTimeInMillis();

		return (cal);
	}



	/**
	 * @param msh
	 * @param dateOfMessage
	 * @param facilityName facility.getName();
	 * @param messageCode i.e. "REF"
	 * @param triggerEvent i.e. "I12"
	 * @param messageStructure i.e. "REF_I12"
	 * @param hl7VersionId is the version of hl7 in use, i.e. "2.6"
	 */
	public static void fillMsh(MSH msh, Date dateOfMessage, String facilityName, String messageCode, String triggerEvent, String messageStructure, String hl7VersionId) throws DataTypeException {
		msh.getFieldSeparator().setValue("|");
		msh.getEncodingCharacters().setValue("^~\\&");
		msh.getVersionID().getVersionID().setValue(hl7VersionId);

		//msh.getDateTimeOfMessage().setValue(getAsHl7FormattedString(dateOfMessage));

		msh.getSendingApplication().getNamespaceID().setValue("OSCAR");

		msh.getSendingFacility().getNamespaceID().setValue(facilityName);

		// message code "REF", event "I12", structure "REF I12"
		msh.getMessageType().getMessageCode().setValue(messageCode);
		msh.getMessageType().getTriggerEvent().setValue(triggerEvent);
		msh.getMessageType().getMessageStructure().setValue(messageStructure);
	}

	/**
	 * @param sft
	 * @param version major version if available
	 * @param build build date or build number if available
	 */
	public static void fillSft(SFT sft, String version, String build) throws DataTypeException {
		sft.getSoftwareVendorOrganization().getOrganizationName().setValue("OSCARMcMaster");
		sft.getSoftwareCertifiedVersionOrReleaseNumber().setValue(version);
		sft.getSoftwareProductName().setValue("OSCAR");
		sft.getSoftwareBinaryID().setValue(build);
	}



	/**
	 * This method returns a non-persisted, detached demographic model object.
	 * 
	 * @throws HL7Exception
	 */
	public static Demographic parsePid(PID pid) throws HL7Exception {
		Demographic demographic = new Demographic();

		XAD xad = pid.getPatientAddress(0);
		demographic.setAddress(StringUtils.trimToNull(xad.getStreetAddress().getStreetOrMailingAddress().getValue()));
		demographic.setCity(StringUtils.trimToNull(xad.getCity().getValue()));
		demographic.setProvince(StringUtils.trimToNull(xad.getStateOrProvince().getValue()));
		demographic.setPostal(StringUtils.trimToNull(xad.getZipOrPostalCode().getValue()));




		GregorianCalendar birthDate = DataTypeUtils.getCalendarFromDTM(pid.getDateTimeOfBirth().getTime());
		demographic.setBirthDay(birthDate);

		CX cx = pid.getPatientIdentifierList(0);
		// health card string, excluding version code
		demographic.setHin(StringUtils.trimToNull(cx.getIDNumber().getValue()));
		// blank for everyone but ontario use version code
		//  demographic.setVer(StringUtils.trimToNull(cx.getIdentifierCheckDigit().getValue()));
		// province
		demographic.setHcType(StringUtils.trimToNull(cx.getAssigningJurisdiction().getIdentifier().getValue()));
		// valid
		GregorianCalendar tempCalendar = DataTypeUtils.getCalendarFromDT(cx.getEffectiveDate());
		if (tempCalendar != null) demographic.setEffDate(tempCalendar.getTime());
		// expire
		tempCalendar = DataTypeUtils.getCalendarFromDT(cx.getExpirationDate());
		if (tempCalendar != null) demographic.setHcRenewDate(tempCalendar.getTime());

		XPN xpn = pid.getPatientName(0);
		demographic.setLastName(StringUtils.trimToNull(xpn.getFamilyName().getSurname().getValue()));
		demographic.setFirstName(StringUtils.trimToNull(xpn.getGivenName().getValue()));

		XTN phone = pid.getPhoneNumberHome(0);
		demographic.setPhone(StringUtils.trimToNull(phone.getUnformattedTelephoneNumber().getValue()));

		Gender gender = getOscarGenderFromHl7Gender(pid.getAdministrativeSex().getValue());
		if (gender != null) demographic.setSex(gender.name());

		return (demographic);
	}

	/**
	 * Given an oscar gender, this will return an hl7 gender.
	 */
	public static String getHl7GenderFromOscarGender(String oscarGender) {
		Gender gender = null;

		try {
			gender = Gender.valueOf(oscarGender);
		} catch (NullPointerException e) {
			// this is okay, means there's no gender
		} catch (Exception e) {
			// this is not okay...
			logger.error("Missed gender or dirty data in database. demographic.sex=" + oscarGender);
		}

		return (getHl7GenderFromOscarGender(gender));
	}

	/**
	 * Given an oscar gender, this will return an hl7 gender.
	 */
	public static String getHl7GenderFromOscarGender(Gender oscarGender) {
		if (oscarGender == null) return ("U");

		if (Gender.M == oscarGender) return ("M");
		else if (Gender.F == oscarGender) return ("F");
		else if (Gender.O == oscarGender) return ("O");
		else if (Gender.T == oscarGender) return ("A");
		else if (Gender.U == oscarGender) return ("N");
		else {
			logger.error("Missed gender or dirty data in database. demographic.sex=" + oscarGender);
			return ("U");
		}
	}

	/**
	 * Given an hl7 gender, this will return an oscarGender
	 */
	public static Gender getOscarGenderFromHl7Gender(String hl7Gender) {
		if (hl7Gender == null) return (null);

		hl7Gender = hl7Gender.toUpperCase();

		if ("M".equals(hl7Gender)) return (Gender.M);
		else if ("F".equals(hl7Gender)) return (Gender.F);
		else if ("O".equals(hl7Gender)) return (Gender.O);
		else if ("A".equals(hl7Gender)) return (Gender.T);
		else if ("N".equals(hl7Gender)) return (Gender.U);
		else if ("U".equals(hl7Gender)) return (null);
		else throw (new IllegalArgumentException("Missed gender : " + hl7Gender));
	}

	/**
	 * @param nte
	 * @param subject should be a short string denoting what's in the comment data, i.e. "REASON_FOR_REFERRAL" or "ALLERGIES", max length is 250
	 * @param fileName should be the file name if applicable, can be null if it didn't come from a file.
	 * @param data and binary data, a String must pass in bytes too as it needs to be base64 encoded for \n and \r's
	 * @throws HL7Exception
	 * @throws UnsupportedEncodingException
	 */
	public static void fillNte(NTE nte, String subject, String fileName, byte[] data) throws HL7Exception, UnsupportedEncodingException {

		nte.getCommentType().getText().setValue(subject);
		if (fileName != null) nte.getCommentType().getNameOfCodingSystem().setValue(fileName);

		String stringData = encodeToBase64String(data);
		int dataLength = stringData.length();
		int chunks = dataLength / DataTypeUtils.NTE_COMMENT_MAX_SIZE;
		if (dataLength % DataTypeUtils.NTE_COMMENT_MAX_SIZE != 0) chunks++;
		logger.debug("Breaking Observation Data (" + dataLength + ") into chunks:" + chunks);

		for (int i = 0; i < chunks; i++) {
			FT commentPortion = nte.getComment(i);

			int startIndex = i * DataTypeUtils.NTE_COMMENT_MAX_SIZE;
			int endIndex = Math.min(dataLength, startIndex + DataTypeUtils.NTE_COMMENT_MAX_SIZE);

			commentPortion.setValue(stringData.substring(startIndex, endIndex));
		}
	}

	public static byte[] getNteCommentsAsSingleDecodedByteArray(NTE nte) throws UnsupportedEncodingException {
		FT[] fts = nte.getComment();

		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < fts.length; i++)
			sb.append(fts[i].getValue());

		return (decodeBase64(sb.toString()));
	}

	/**
	 * @param rol
	 * @param provider
	 * @param actionRole the role of the given provider with regards to this communcations. There is HL7 table 0443. We will also add DataTypeUtils.ACTION_ROLE_* as roles so we can send and receive arbitrary data under arbitrary conditions.
	 * @throws HL7Exception
	 */
	public static void fillRol(ROL rol, Provider provider, String actionRole) throws HL7Exception {
		rol.getActionCode().setValue("unused");
		rol.getRoleROL().getIdentifier().setValue(actionRole);

		XCN xcn = rol.getRolePerson(0);
		xcn.getIDNumber().setValue(provider.getProviderNo());
		xcn.getFamilyName().getSurname().setValue(provider.getLastName());
		xcn.getGivenName().setValue(provider.getFirstName());
		//xcn.getPrefixEgDR().setValue(provider.getTitle());

		XAD xad = rol.getOfficeHomeAddressBirthplace(0);
		xad.getStreetAddress().getStreetOrMailingAddress().setValue(StringUtils.trimToNull(provider.getAddress()));
		xad.getAddressType().setValue("O");

		XTN xtn = rol.getPhone(0);
		xtn.getUnformattedTelephoneNumber().setValue(provider.getPhone());
		//xtn.getCommunicationAddress().setValue(provider.getEmail());
	}

	/**
	 * The provider returned is just a detached/unmanaged Provider object which may not represent an entry in the db, it is used as a data structure only.
	 * 
	 * @throws HL7Exception
	 */
	public static Provider parseRolAsProvider(ROL rol) throws HL7Exception {
		Provider provider = new Provider();

		XCN xcn = rol.getRolePerson(0);
		provider.setProviderNo(StringUtils.trimToNull(xcn.getIDNumber().getValue()));
		provider.setLastName(StringUtils.trimToNull(xcn.getFamilyName().getSurname().getValue()));
		provider.setFirstName(StringUtils.trimToNull(xcn.getGivenName().getValue()));
		//provider.setTitle(StringUtils.trimToNull(xcn.getPrefixEgDR().getValue()));

		XAD xad = rol.getOfficeHomeAddressBirthplace(0);
		provider.setAddress(StringUtils.trimToNull(xad.getStreetAddress().getStreetOrMailingAddress().getValue()));

		XTN xtn = rol.getPhone(0);
		provider.setPhone(StringUtils.trimToNull(xtn.getUnformattedTelephoneNumber().getValue()));
		//provider.setEmail(StringUtils.trimToNull(xtn.getCommunicationAddress().getValue()));

		return (provider);
	}


}
