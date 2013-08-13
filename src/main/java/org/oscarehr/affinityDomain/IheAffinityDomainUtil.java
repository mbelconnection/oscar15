/**
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved.
 * This software is published under the GPL GNU General Public License.
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version. 
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * This software was written for the
 * Department of Family Medicine
 * McMaster University
 * Hamilton
 * Ontario, Canada
 */


package org.oscarehr.affinityDomain;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.oscarehr.common.dao.ClinicDAO;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.EFormDao;
import org.oscarehr.common.dao.EFormDataDao;
import org.oscarehr.common.dao.ExternalDemographicDao;
import org.oscarehr.common.dao.ProviderDataDao;
import org.oscarehr.common.model.Clinic;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.EForm;
import org.oscarehr.common.model.EFormData;
import org.oscarehr.common.model.ExternalDemographic;
import org.oscarehr.common.model.ProviderData;
import org.oscarehr.document.dao.DocumentDAO;
import org.oscarehr.document.model.Document;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;
import org.oscarehr.web.eform.EfmParser;

import oscar.OscarProperties;
import oscar.dms.EDocUtil;
import oscar.oscarDemographic.pageUtil.Util;
import ca.marc.ihe.core.AddressPartType;
import ca.marc.ihe.core.AddressUse;
import ca.marc.ihe.core.CodeValue;
import ca.marc.ihe.core.DocumentMetaData;
import ca.marc.ihe.core.DocumentSubmissionSetMetaData;
import ca.marc.ihe.core.DomainIdentifier;
import ca.marc.ihe.core.Gender;
import ca.marc.ihe.core.LocationDemographic;
import ca.marc.ihe.core.NameUse;
import ca.marc.ihe.core.PartType;
import ca.marc.ihe.core.PersonAddress;
import ca.marc.ihe.core.PersonDemographic;
import ca.marc.ihe.core.PersonName;
import ca.marc.ihe.core.configuration.IheActorType;
import ca.marc.ihe.core.configuration.IheAffinityDomainConfiguration;
import ca.marc.ihe.core.configuration.IheConfiguration;
import ca.marc.ihe.pix.PixCommunicator;
import ca.marc.ihe.xds.XdsCommunicator;
import ca.marc.ihe.xds.XdsDocumentFactory;

public class IheAffinityDomainUtil {

	private ExternalDemographicDao externalDemographicDao = (ExternalDemographicDao) SpringUtils.getBean("externalDemographicDao");
	private ProviderDataDao providerDataDao = (ProviderDataDao) SpringUtils.getBean("providerDataDao");

	private EFormDataDao eFormDataDao = (EFormDataDao) SpringUtils.getBean("EFormDataDao");
	private DocumentDAO documentDao = (DocumentDAO) SpringUtils.getBean("documentDAO");
	private ClinicDAO clinicDao = (ClinicDAO) SpringUtils.getBean("clinicDAO");
	private IheAffinityDomainConfiguration affinityDomainConfig;
	
	private OscarProperties oscarProperties = OscarProperties.getInstance();
	private final String OscarRootId = oscarProperties.getProperty("OSCAR_ROOT_ID", null);


	/**
	 * 
	 * @param affinityDomainName The name of the affinity domain to use.
	 * @throws Exception
	 */
	public IheAffinityDomainUtil(String affinityDomainName) throws Exception {
		IheConfiguration config = IheConfigurationUtil.load();
		
		try {
			affinityDomainConfig = config.getAffinityDomain(affinityDomainName);
			
		} catch (Exception e) {
			throw e;
		}

	}

	/**
	 * Registers EForms on the affinity domain's xds repository.
	 * @param providerNumber Oscar provider id.
	 * @param demographicId Oscar patient id.
	 * @param documentIds Oscar ids of the EForms to register.
	 * @return True if the documents are successfully registered.
	 */
	public boolean registerEForms(String providerNumber, int demographicId, String[] documentIds, String confidentiality) {
		boolean retVal = false;
		MiscUtils.getLogger().debug("Register eform.");
		try {
		
			XdsCommunicator xdsCommunicator = new XdsCommunicator(affinityDomainConfig);
			ProviderData provider = providerDataDao.findByProviderNo(providerNumber);
			DocumentSubmissionSetMetaData docSubData = generateDocSubMetaData(providerNumber, demographicId);
			
			// Loop through every selected document and add it to the register message.
			for (String docId : documentIds) {
				MiscUtils.getLogger().debug("Generating document meta data.");
				DocumentMetaData meta = new DocumentMetaData();
				
				//  ID^LNAME^GNAME^GNAME2^SUFFIX^PREFIX^^^^&ROOT&ISO
				meta.addExtendedAttribute("legalAuthenticator", String.format("%s^%s^%s^^%s^^^^^&%s&ISO", 
						provider.getId(), provider.getLastName(), provider.getFirstName(), provider.getTitle(), OscarRootId));
				// TODO: get the oscar facility name (from properties? config?)
				meta.addExtendedAttribute("authorInstitution", oscarProperties.getProperty("OSCAR_CLINIC_NAME", null));
	
				// Get the raw eform data.
				EFormData data = eFormDataDao.findByFormDataId(Integer.parseInt(docId));
	
				// Clean up the eform with tagsoup.
				EfmParser parser = new EfmParser(Integer.toString(data.getFormId()));
				
				byte[] content = parser.parse(data.getFormData()).getBytes();
	
				meta.setContent(content);
	
				//meta.setDocumentUniqueId(identifier);
				meta.setMimeType("text/xml");
	
				meta.setTitle(data.getFormName());
				
				meta.setCreationTime(Calendar.getInstance());
				
				DomainIdentifier documentId = new DomainIdentifier();
				documentId.setRoot(OscarRootId);
				documentId.setExtension(data.getId().toString());
				meta.setDocumentUniqueId(documentId);
	
				CodeValue contentType = new CodeValue();
				contentType.setCode("History and Physical");
				contentType.setCodeSystem("Connect-a-thon contentTypeCodes");
				contentType.setDisplayName("History and Physical");
	
				meta.setContentType(contentType);
				
				
				EFormDao eFormDao = (EFormDao) SpringUtils.getBean("EFormDao");
				EForm eForm = eFormDao.findById(data.getFormId());
	
				CodeValue classCode = new CodeValue();
				classCode.setCode(eForm.getSubject());
				classCode.setCodeSystem("OSCAR Specific Value");
				classCode.setDisplayName(eForm.getSubject());
				meta.setClassCode(classCode);
	
				CodeValue confidentialityCode = new CodeValue();
				confidentialityCode.setCode(confidentiality);
				confidentialityCode.setCodeSystem("2.16.840.1.113883.5.25");
				confidentialityCode.setDisplayName("Connect-a-thon confidentialityCodes");
				meta.setConfidentiality(confidentialityCode);
	
				CodeValue formatCode = new CodeValue();
				formatCode.setCode("urn:ad:oscar:xhtml-form");
				formatCode.setCodeSystem("OSCAR Specific Value");
				formatCode.setDisplayName("urn:ad:oscar:xhtml-form");
				meta.setFormat(formatCode);
				
				CodeValue healthcareFacilityTypeCode = new CodeValue();
				healthcareFacilityTypeCode.setCode("Outpatient");
				healthcareFacilityTypeCode.setCodeSystem("Connect-a-thon healthcareFacilityTypeCodes");
				healthcareFacilityTypeCode.setDisplayName("Outpatient");
				meta.setFacilityType(healthcareFacilityTypeCode);
	
				CodeValue practiceSettingCode = new CodeValue();
				practiceSettingCode.setCode("General Medicine");
				practiceSettingCode.setCodeSystem("Connect-a-thon practiceSettingCodes");
				practiceSettingCode.setDisplayName("General Medicine");
				meta.setPracticeSetting(practiceSettingCode);
	
				CodeValue typeCode = new CodeValue();
				typeCode.setCode("52033-8");
				typeCode.setCodeSystem("LOINC");
				typeCode.setDisplayName("General Correspondence");
				meta.setType(typeCode);
	
				docSubData.addDocument(meta);
			}
			MiscUtils.getLogger().debug("Registering document on the xds");
			retVal = xdsCommunicator.register(docSubData);
			
			MiscUtils.getLogger().debug("Eform was sent to XDS");
		
		} catch (Exception e) {
			MiscUtils.getLogger().debug("Exception: " + e.getMessage());
			retVal = false;
		}
		
		return retVal;
	}
	
	
	/**
	 * Registers EDocs on the affinity domain's xds repository.
	 * @param providerNumber Oscar provider id.
	 * @param demographicId Oscar patient id.
	 * @param documentIds Oscar ids of the EDocs to register.
	 * @return True if the documents are successfully registered.
	 */
	public boolean registerEDocs(String providerNumber, int demographicId, String[] documentIds, String confidentiality) {
		boolean retVal = false;
		
		try {
		
			XdsCommunicator xdsCommunicator = new XdsCommunicator(affinityDomainConfig);
			ProviderData provider = providerDataDao.findByProviderNo(providerNumber);
			DocumentSubmissionSetMetaData docSubData = generateDocSubMetaData(providerNumber, demographicId);
			
			// Loop through every selected document and add it to the register message.
			for (String docId : documentIds) {
				DocumentMetaData meta = new DocumentMetaData();
				
				//  ID^LNAME^GNAME^GNAME2^SUFFIX^PREFIX^^^^&ROOT&ISO
				meta.addExtendedAttribute("legalAuthenticator", String.format("%s^%s^%s^^%s^^^^^&%s&ISO", 
						provider.getId(), provider.getLastName(), provider.getFirstName(), provider.getTitle(), OscarRootId));
				// TODO: get the oscar facility name (from properties? config?)
				meta.addExtendedAttribute("authorInstitution", oscarProperties.getProperty("OSCAR_CLINIC_NAME", null));
	
				// Get the Document data (content & metadata)
				Document edoc = documentDao.getDocument(docId);
				
				// get the actual document content from the filesystem
				String edocDir = oscarProperties.getProperty("DOCUMENT_DIR");
				File file = new File(edocDir + "/" + edoc.getDocfilename());
				try {
					FileInputStream fin = new FileInputStream(file);
					byte content[] = new byte[(int)file.length()];
					fin.read(content);
					meta.setContent(content);
					
				} catch (Exception e) {
					MiscUtils.getLogger().debug("Exception: " + e.getMessage());
					throw e;
				}
				
				meta.setMimeType(edoc.getContenttype());
				meta.setTitle(edoc.getDocdesc());
				meta.setCreationTime(Calendar.getInstance());
				
				DomainIdentifier documentId = new DomainIdentifier();
				documentId.setRoot(OscarRootId);
				documentId.setExtension(edoc.getId().toString());
				meta.setDocumentUniqueId(documentId);
	
				CodeValue contentType = new CodeValue();
				contentType.setCode("History and Physical");
				contentType.setCodeSystem("Connect-a-thon contentTypeCodes");
				contentType.setDisplayName("History and Physical");
	
				meta.setContentType(contentType);
				
				// get the classcode value for the document type
				CodeValue classCode = new CodeValue();
				classCode.setCode(edoc.getDoctype());
				classCode.setCodeSystem("OSCAR Specific Value");
				classCode.setDisplayName(edoc.getDoctype());
				meta.setClassCode(classCode);
	
				CodeValue confidentialityCode = new CodeValue();
				confidentialityCode.setCode(confidentiality);
				confidentialityCode.setCodeSystem("2.16.840.1.113883.5.25");
				confidentialityCode.setDisplayName("Connect-a-thon confidentialityCodes");
				meta.setConfidentiality(confidentialityCode);
	
				CodeValue formatCode = new CodeValue();
				formatCode.setCode("urn:ad:oscar:xhtml-form");
				formatCode.setCodeSystem("OSCAR Specific Value");
				formatCode.setDisplayName("urn:ad:oscar:xhtml-form");
				meta.setFormat(formatCode);
				
				CodeValue healthcareFacilityTypeCode = new CodeValue();
				healthcareFacilityTypeCode.setCode("Outpatient");
				healthcareFacilityTypeCode.setCodeSystem("Connect-a-thon healthcareFacilityTypeCodes");
				healthcareFacilityTypeCode.setDisplayName("Outpatient");
				meta.setFacilityType(healthcareFacilityTypeCode);
	
				CodeValue practiceSettingCode = new CodeValue();
				practiceSettingCode.setCode("General Medicine");
				practiceSettingCode.setCodeSystem("Connect-a-thon practiceSettingCodes");
				practiceSettingCode.setDisplayName("General Medicine");
				meta.setPracticeSetting(practiceSettingCode);
	
				CodeValue typeCode = new CodeValue();
				typeCode.setCode("52033-8");
				typeCode.setCodeSystem("LOINC");
				typeCode.setDisplayName("General Correspondence");
				meta.setType(typeCode);
	
				docSubData.addDocument(meta);
			}
			
			retVal = xdsCommunicator.register(docSubData);
			
		} catch (Exception e) {
			MiscUtils.getLogger().debug("Exception: " + e.getMessage());
		}
		
		return retVal;
	}
	
	
	/**
	 * Registers a CDS Demographic Export zip file on the affinity domain's xds repository.
	 * @param providerNumber Oscar provider id.
	 * @param demographicId Oscar patient id.
	 * @param zipFile the absolute path to the zip file containing the CDS files
	 * @return True if the document was successfully registered.
	 */
	public boolean registerCDSExport(String providerNumber, int demographicId, String zipFile,  String confidentiality) {
		boolean retVal = false;
		
		try {
		
			XdsCommunicator xdsCommunicator = new XdsCommunicator(affinityDomainConfig);
			ProviderData provider = providerDataDao.findByProviderNo(providerNumber);
			DocumentSubmissionSetMetaData docSubData = generateDocSubMetaData(providerNumber, demographicId);
			
			// There is only one document (zip file) to send to xds
			DocumentMetaData meta = new DocumentMetaData();
			
			//  legalAuthenticator: ID^LNAME^GNAME^GNAME2^SUFFIX^PREFIX^^^^&ROOT&ISO
			meta.addExtendedAttribute("legalAuthenticator", String.format("%s^%s^%s^^%s^^^^^&%s&ISO", 
					provider.getId(), provider.getLastName(), provider.getFirstName(), provider.getTitle(), OscarRootId));
			// oscar facility name (from oscar properties)
			meta.addExtendedAttribute("authorInstitution", oscarProperties.getProperty("OSCAR_CLINIC_NAME", null));

			// Get the zip file's content
			File file = new File(zipFile);
			try {
				FileInputStream fin = new FileInputStream(file);
				byte content[] = new byte[(int)file.length()];
				fin.read(content);
				meta.setContent(content);
				
			} catch (Exception e) {
				MiscUtils.getLogger().debug("Exception: " + e.getMessage());
				throw e;
			}

			meta.setMimeType("application/zip");
			meta.setTitle("CDS Demographic Export");
			meta.setCreationTime(Calendar.getInstance());
			
			DomainIdentifier documentId = new DomainIdentifier();
			documentId.setRoot(OscarRootId);
			documentId.setExtension(String.valueOf(System.currentTimeMillis()));
			meta.setDocumentUniqueId(documentId);

			CodeValue contentType = new CodeValue();
			contentType.setCode("History and Physical");
			contentType.setCodeSystem("Connect-a-thon contentTypeCodes");
			contentType.setDisplayName("History and Physical");

			meta.setContentType(contentType);
			
			// get the classcode value for the document type
			CodeValue classCode = new CodeValue();
			// TODO: get classCode from Justin
			classCode.setCode("Study Enrollment Form");
			classCode.setCodeSystem("OSCAR Specific Value");
			// TODO: get classCode from Justin
			classCode.setDisplayName("Study Enrollment Form");
			meta.setClassCode(classCode);

			CodeValue confidentialityCode = new CodeValue();
			confidentialityCode.setCode(confidentiality);
			confidentialityCode.setCodeSystem("2.16.840.1.113883.5.25");
			confidentialityCode.setDisplayName("Connect-a-thon confidentialityCodes");
			meta.setConfidentiality(confidentialityCode);

			CodeValue formatCode = new CodeValue();
			formatCode.setCode("urn:ad:oscar:xhtml-form");
			formatCode.setCodeSystem("OSCAR Specific Value");
			formatCode.setDisplayName("urn:ad:oscar:xhtml-form");
			meta.setFormat(formatCode);
			
			CodeValue healthcareFacilityTypeCode = new CodeValue();
			healthcareFacilityTypeCode.setCode("Outpatient");
			healthcareFacilityTypeCode.setCodeSystem("Connect-a-thon healthcareFacilityTypeCodes");
			healthcareFacilityTypeCode.setDisplayName("Outpatient");
			meta.setFacilityType(healthcareFacilityTypeCode);

			CodeValue practiceSettingCode = new CodeValue();
			practiceSettingCode.setCode("General Medicine");
			practiceSettingCode.setCodeSystem("Connect-a-thon practiceSettingCodes");
			practiceSettingCode.setDisplayName("General Medicine");
			meta.setPracticeSetting(practiceSettingCode);

			CodeValue typeCode = new CodeValue();
			// TODO: get typeCode from Justin
			typeCode.setCode("52033-8");
			typeCode.setCodeSystem("LOINC");
			typeCode.setDisplayName("General Correspondence");
			meta.setType(typeCode);

			docSubData.addDocument(meta);
			
			retVal = xdsCommunicator.register(docSubData);
			
			// Remove the temp files generated by the cds export
			Util.cleanFile(zipFile);
			
		} catch (Exception e) {
			MiscUtils.getLogger().debug("Exception: " + e.getMessage());
		}
		
		return retVal;
	}
	
	
	/**
	 * Sends a BPPC (Basic Patient Privacy Concent) document to the XDS Actor in the affinity domain.
	 * @param providerNumber Oscar provider id (logged in doctor)
	 * @param demographicId Oscar patient id.
	 * @param authenticatorId Oscar demographic id of the person acting on behalf of the patient (guardian?)
	 * @return True if the BPPC document was successfully registered.
	 */
	public boolean sendBppc(String providerNumber, int demographicId, int authenticatorId) {
		boolean retVal = false;
		
		try {
			
			XdsCommunicator xdsCommunicator = new XdsCommunicator(affinityDomainConfig);
			
			// target
			PersonDemographic target = createPatientDemographic(demographicId, true);
			
			// author
			PersonDemographic author = createAuthorDemographic(providerNumber);
			
			// authenticator
			PersonDemographic authenticator = createPatientDemographic(authenticatorId, false);
			
			// location (id, name, phone, address)
			DomainIdentifier locationId = new DomainIdentifier();
			locationId.setExtension("");
			locationId.setAssigningAuthority(affinityDomainConfig.getActor(IheActorType.PAT_IDENTITY_X_REF_MGR).getLocalIdentification().getUniqueId());
			locationId.setRoot(OscarRootId);
			// clinic info
			Clinic oscarClinic = clinicDao.getClinic();
			PersonAddress address = new PersonAddress(AddressUse.Home);
			address.addAddressPart(oscarClinic.getClinicAddress(), AddressPartType.AddressLine);
			address.addAddressPart(oscarClinic.getClinicCity(), AddressPartType.City);
			address.addAddressPart(oscarClinic.getClinicProvince(), AddressPartType.State);
			address.addAddressPart(oscarClinic.getClinicPostal(), AddressPartType.Zipcode);
			LocationDemographic location = new LocationDemographic(locationId, oscarClinic.getClinicName(), oscarClinic.getClinicPhone(), address);
			
			// consent
			CodeValue consentGiven = new CodeValue();
			consentGiven.setCode("57016-8");
			consentGiven.setCodeSystem("2.16.840.1.113883.6.1");
			consentGiven.setDisplayName("PATIENT PRIVACY ACKNOWLEDGEMENT");
			
			XdsDocumentFactory util = new XdsDocumentFactory(affinityDomainConfig);
			DocumentSubmissionSetMetaData docSubData = util.createBppc(target, author, authenticator, OscarRootId, location, consentGiven, null, null);
			
			retVal = xdsCommunicator.register(docSubData);
			
			// add the consent document to the edocs
			if (retVal) {
				String fileName = affinityDomainConfig.getName() + "SharingConsentDocument-" + System.currentTimeMillis() + ".xml";
		        
		        FileOutputStream out = new FileOutputStream(oscarProperties.getProperty("DOCUMENT_DIR") + "/" + fileName);
		        out.write(docSubData.getDocuments().get(0).getContent());
		        
		        // Add edoc entry
		        Calendar cal = Calendar.getInstance();
		        DateFormat dayFormat = new SimpleDateFormat("yyyy-MM-dd");
		        DateFormat timeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		        EDocUtil.addDocument(
	        		String.valueOf(demographicId), 
	        		fileName, 
	        		affinityDomainConfig.getName() + " Sharing Consent Document", 
	        		"others", 
	        		"", 
	        		"", 
	        		"text/xml", 
	        		dayFormat.format(cal.getTime()), 
	        		timeFormat.format(cal.getTime()), 
	        		providerNumber, 
	        		"", // responsible
	        		"", // reviewer
	        		null, 
	        		"", // source
	        		""	// sourceFacility
		        );
		        
		        out.close();
			}
			
		} catch (Exception e) {
			MiscUtils.getLogger().debug("Exception: " + e.getMessage());
		}
		
		return retVal;
	}
	
	
	/**
	 * Generates an xds document submission metadata object containing patient and author demographic info
	 * @param providerNumber Oscar provider id.
	 * @param demographicId Oscar patient id.
	 * @return DocumentSubmissionSetMetaData object containing patient & author demographic information
	 */
	private DocumentSubmissionSetMetaData generateDocSubMetaData(String providerNumber, int demographicId) throws Exception {
		
		DocumentSubmissionSetMetaData retVal = new DocumentSubmissionSetMetaData();

		DomainIdentifier identifier = new DomainIdentifier();
		identifier.setExtension("");
		identifier.setAssigningAuthority(affinityDomainConfig.getActor(IheActorType.PAT_IDENTITY_X_REF_MGR).getLocalIdentification().getUniqueId());
		identifier.setRoot(OscarRootId);
		retVal.setId(identifier);
		
		PersonDemographic patient = createPatientDemographic(demographicId, true);
		retVal.setPatient(patient);
		
		// Set the author of the document to the oscar provider.
		PersonDemographic author = createAuthorDemographic(providerNumber);
		retVal.setAuthor(author);
		
		return retVal;
	}

	/**
	 * Share (Register/Update) the patient on the affinity domain
	 * @param demographicId Oscar patient id.
	 * @return True if the patient was successfully registered.
	 * @throws Exception
	 */
	public boolean sharePatient(int demographicId) throws Exception {
		boolean shareResult = false;
		if (affinityDomainConfig != null) {

			ExternalDemographic externalDemographic = externalDemographicDao.findExternalDemographic(affinityDomainConfig.getName(), demographicId);

			// If the patient doesn't exist in external demographics, perform register
			if (externalDemographic == null) {
				
				shareResult = this.registerPatient(demographicId);

			} else {
				// The patient exists, perform a PIX update (which reactivates sharing automatically)
				if (!externalDemographic.isActive()) {
					shareResult = this.updatePatient(externalDemographic);
				}
			}
		}
		
		return shareResult;
	}
	
	
	/**
	 * Registers a patient in the affinity domain (PIX Register)
	 * @param demographicId the oscar patient id
	 * @return True if the patient was registered on the affinity domain's PIX Manager
	 * @throws Exception 
	 */
	public boolean registerPatient(int demographicId) throws Exception {
		boolean registerResult = false;
		PersonDemographic personDemographic = createPatientDemographic(demographicId, false);
		PixCommunicator pixCommunicator = new PixCommunicator(affinityDomainConfig);
		
		try {

			// Register the patient on the pix manager.
			registerResult = pixCommunicator.register(personDemographic);

			if (registerResult) {

				// Add the patient to the external demographics.
				ExternalDemographic model = new ExternalDemographic();
				model.setAffinityDomain(affinityDomainConfig.getName());
				model.setCreatedUTC(new Date());
				model.setDemographic_no(demographicId);
				model.setLastDisabled(null);
				model.setLastEnabled(new Date());
				model.setUpdateEnabled(true);
				model.setActive(true);
				externalDemographicDao.persist(model);

			}

		} catch (Exception e) {
			registerResult = false;
			throw e;
		}
		
		return registerResult;
	}
	
	
	/**
	 * Update patient in the affinity domain (PIX Update)
	 * @param externalDemographic Oscar External demographic record
	 * @return True if the patient was updated on the affinity domain's PIX Manager
	 * @throws Exception 
	 */
	public boolean updatePatient(ExternalDemographic externalDemographic) throws Exception {
		boolean updateResult = false;
		PersonDemographic personDemographic = createPatientDemographic(externalDemographic.getDemographic_no(), false);
		
		PixCommunicator pixCommunicator = new PixCommunicator(affinityDomainConfig);
		
		try {

			// Update the patient on the pix manager.
			updateResult = pixCommunicator.update(personDemographic);

			if (updateResult) {

				// Update the patient in our external demographics.
				externalDemographic.setActive(true);
				externalDemographic.setLastEnabled(new Date());
				externalDemographicDao.merge(externalDemographic);

			}

		} catch (Exception e) {
			updateResult = false;
			throw e;
		}
		
		return updateResult;
	}
	

	/**
	 * Check if a patient is registered on the affinity domain.
	 * @param demographicId Oscar patient id.
	 * @return True if the patient is registered and active on the affinity domain.
	 */
	public boolean isPatientRegistered(int demographicId) {

		if (affinityDomainConfig != null) {
			return externalDemographicDao.isPatientRegisteredAndActive(affinityDomainConfig.getName(), demographicId);
		}

		return false;
	}

	/**
	 * Stops the sharing of the patient's data with the affinity domain.
	 * @param demographicId Oscar patient id.
	 */
	public void deactivateSharing(int demographicId) {

		// get the external demographic
		ExternalDemographic externalDemographic = externalDemographicDao.findExternalDemographic(affinityDomainConfig.getName(), demographicId);

		// deactivate if an external demographic record was found
		if (externalDemographic != null) {
			externalDemographic.setActive(false);
			externalDemographic.setLastDisabled(new Date());
			externalDemographicDao.merge(externalDemographic);
		}

	}
	
	/**
	 * Creates the Person Demographic object that will be used to register/update a patient in the PIX manager
	 * @param demographicId the oscar patient id
	 * @return
	 * @throws Exception 
	 */
	private PersonDemographic createPatientDemographic(int demographicId, boolean resolveIdentifiers) throws Exception {
		
		PersonDemographic retVal = null;
		
		PersonDemographic patient = new PersonDemographic();
		DemographicDao demographicDao = (DemographicDao) SpringUtils.getBean("demographicDao");
		Demographic patientDemographic = demographicDao.getDemographicById(demographicId);
		
		// Set the patient's gender.
		if (patientDemographic.getSex().equals("M")) {
			patient.setGender(Gender.M);
		} else if (patientDemographic.getSex().equals("F")) {
			patient.setGender(Gender.F);
		}
		
		// Set the patient's date of birth.
		int day = Integer.parseInt(patientDemographic.getDateOfBirth());
		int month = Integer.parseInt(patientDemographic.getMonthOfBirth());
		int year = Integer.parseInt(patientDemographic.getYearOfBirth());

		// Month has a 0 index.. (January is month 0)
		Date dateOfBirth = new GregorianCalendar(year, month-1, day).getTime();

		patient.setDateOfBirth(dateOfBirth);

		// Set the patient's name.
		PersonName name = new PersonName();
		name.addNamePart(patientDemographic.getFirstName(), PartType.Given);
		name.addNamePart(patientDemographic.getLastName(), PartType.Family);
		name.setUse(NameUse.Legal);
		patient.getNames().add(name);
		
		PersonAddress address = new PersonAddress(AddressUse.Home);
		address.addAddressPart(patientDemographic.getAddress(), AddressPartType.AddressLine);
		address.addAddressPart(patientDemographic.getCity(), AddressPartType.City);
		address.addAddressPart(patientDemographic.getProvince(), AddressPartType.State);
		// Will pass an empty string for the Country, since Oscar doesn't store it
		address.addAddressPart("", AddressPartType.Country);
		address.addAddressPart(patientDemographic.getPostal(), AddressPartType.Zipcode);
		patient.getAddresses().add(address);

		// Set the patient's oscar identifier
		DomainIdentifier patientId = new DomainIdentifier();
		patientId.setRoot(OscarRootId);
		patientId.setExtension(Integer.toString(demographicId));
		patientId.setAssigningAuthority(affinityDomainConfig.getActor(IheActorType.PAT_IDENTITY_X_REF_MGR).getLocalIdentification().getUniqueId());

		patient.getIdentifiers().add(patientId);
		
		
		// Should I resolve the patient identifier against the PIX Manager?
		if (resolveIdentifiers) {
			PixCommunicator pixCommunicator = new PixCommunicator(affinityDomainConfig);
			try {
				retVal = pixCommunicator.resolveIdentifiers(patient);
			} catch (Exception e) {
				MiscUtils.getLogger().debug("Exception: " + e.getMessage());
				throw e;
			}
		} else {
			// if we are doing a register/update operation, don't resolve (only send the local identifiers)
			retVal = patient;
		}
		
		// set the phone
		if (patientDemographic.getPhone() == null)
			retVal.setPhone("");
		else
			retVal.setPhone(patientDemographic.getPhone());
		
		return retVal;
	}
	
	
	/**
	 * Creates a Person Demographic object for the author (Oscar provider/doctor)
	 * @param demographicId the oscar provider id
	 * @return
	 */
	private PersonDemographic createAuthorDemographic(String providerNumber) {
		
		PersonDemographic retVal = new PersonDemographic();
		ProviderData provider = providerDataDao.findByProviderNo(providerNumber);
		
		if (provider.getSex().equals("M")) {
			retVal.setGender(Gender.M);
		} else if (provider.getSex().equals("F")) {
			retVal.setGender(Gender.F);
		}
		
		// Set the oscar identifier.
		DomainIdentifier authorInfo = new DomainIdentifier();
		authorInfo.setAssigningAuthority(affinityDomainConfig.getActor(IheActorType.PAT_IDENTITY_X_REF_MGR).getLocalIdentification().getUniqueId());
		authorInfo.setRoot(OscarRootId);
		authorInfo.setExtension(provider.getId());
		retVal.addIdentifier(authorInfo);
		
		PersonName authName = new PersonName();
		authName.setUse(NameUse.Legal);
		authName.addNamePart(provider.getFirstName(), PartType.Given);
		authName.addNamePart(provider.getLastName(), PartType.Family);
		retVal.addName(authName);
		
		// set the phone
		if (provider.getPhone() == null)
			retVal.setPhone("");
		else
			retVal.setPhone(provider.getPhone());
		
		return retVal;
	}
	
}
