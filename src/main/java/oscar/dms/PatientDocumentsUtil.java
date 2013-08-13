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


package oscar.dms;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.oscarehr.affinityDomain.IheConfigurationUtil;
import org.oscarehr.common.dao.DemographicDao;
import org.oscarehr.common.dao.PatientDocumentDao;
import org.oscarehr.common.model.Demographic;
import org.oscarehr.common.model.PatientDocument;
import org.oscarehr.util.MiscUtils;
import org.oscarehr.util.SpringUtils;

import oscar.OscarProperties;
import oscar.oscarTickler.TicklerCreator;
import ca.marc.ihe.core.CommunicationsException;
import ca.marc.ihe.core.DocumentMetaData;
import ca.marc.ihe.core.DomainIdentifier;
import ca.marc.ihe.core.Gender;
import ca.marc.ihe.core.NameComponent;
import ca.marc.ihe.core.PartType;
import ca.marc.ihe.core.PersonDemographic;
import ca.marc.ihe.core.configuration.IheActorType;
import ca.marc.ihe.core.configuration.IheAffinityDomainConfiguration;
import ca.marc.ihe.core.configuration.IheConfiguration;
import ca.marc.ihe.pix.PixCommunicator;
import ca.marc.ihe.xds.XdsCommunicator;
import ca.marc.ihe.xds.XdsDocumentMetaData;
import ca.marc.ihe.xds.XdsGuidType;
import ca.marc.ihe.xds.XdsQuerySpecification;

public class PatientDocumentsUtil
{
	private static final OscarProperties oscarProperties = OscarProperties.getInstance();
	private static final String OscarRootId = oscarProperties.getProperty("OSCAR_ROOT_ID", null);
	
	private static PatientDocumentDao patientDocumentDao = (PatientDocumentDao) SpringUtils.getBean("patientDocumentDao");
	
	/**
	 * Get patient documents.
	 * @param demographicId Oscar patient id.
	 * @param offset
	 * @param count
	 * @return
	 */
	public static List<PatientDocument> getDocuments(int demographicId, int offset, int count) {
		return patientDocumentDao.findPatientDocumentsWithPagination(demographicId, offset, count);
	}
	
	public static int getDocumentCount(int demographicId) {
		return patientDocumentDao.getDocumentCount(demographicId);
	}
	
	/**
	 * Get all patient documents.
	 * @param demographicId Oscar patient id.
	 * @return
	 */
	public static List<PatientDocument> getDocuments(int demographicId) {
		return  patientDocumentDao.findPatientDocuments(demographicId);
	}
	
	/**
	 * Download a patient document and store it in edocs.
	 * @return
	 */
	public static boolean downloadDocument(int patientDocumentId, String demographicId, String providerId) {
		boolean downloadResult = true;
		
		try {
			IheConfiguration config = IheConfigurationUtil.load();
			
			// Load the patient document.
			PatientDocument doc = patientDocumentDao.find(patientDocumentId);
			
			IheAffinityDomainConfiguration affinityDomainConfig = config.getAffinityDomain(doc.getAffinityDomain());
			
			XdsCommunicator xds = new XdsCommunicator(affinityDomainConfig);
			
			XdsDocumentMetaData xdsMetaData[] = new XdsDocumentMetaData[1];
			xdsMetaData[0] = new XdsDocumentMetaData();
			
			DomainIdentifier docId = new DomainIdentifier();
			docId.setExtension(doc.getUniqueDocumentId());
			
			xdsMetaData[0].setDocumentUniqueId(docId);
			xdsMetaData[0].setRepositoryUniqueId(doc.getRepositoryUniqueId());
		
			// Store the document in edocs.
	        DocumentMetaData[] externalDocuments = xds.fillInDetails(xdsMetaData);
	        String fileName = doc.getTitle() + System.currentTimeMillis() + ".pdf";
	        
	        FileOutputStream out = new FileOutputStream(oscarProperties.getProperty("DOCUMENT_DIR") + "/" + fileName);
	        out.write(externalDocuments[0].getContent());
	        
	        // Add edoc entry
	        Calendar cal = Calendar.getInstance();
	        DateFormat dayFormat = new SimpleDateFormat("yyyy-MM-dd");
	        DateFormat timeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        EDocUtil.addDocument(
	        		demographicId, 
	        		fileName, 
	        		doc.getTitle(), 
	        		"others", 
	        		"", 
	        		"", 
	        		doc.getMimetype(), 
	        		dayFormat.format(cal.getTime()), 
	        		timeFormat.format(cal.getTime()), 
	        		providerId, 
	        		"", // responsible
	        		"", // reviewer
	        		null, 
	        		"", // source
	        		""	// sourceFacility
	        );
	        
	        // mark the document as downloaded
	        doc.setDownloaded(true);
	        patientDocumentDao.merge(doc);
	        
	        out.close();
	        
        } catch (CommunicationsException e) {
        	MiscUtils.getLogger().debug("CommunicationsException: " + e.getMessage());
	        downloadResult = false;
        } catch (FileNotFoundException e) {
        	MiscUtils.getLogger().debug("FileNotFoundException: " + e.getMessage());
        	downloadResult = false;
        } catch (IOException e) {
        	MiscUtils.getLogger().debug("IOException: " + e.getMessage());
        	downloadResult = false;
        } catch (Exception e) {
        	MiscUtils.getLogger().debug("Exception: " + e.getMessage());
        	downloadResult = false;
        }
		
		return downloadResult;
	}
	
	/**
	 * Fetch all documents for a patient from every affinity domain in the configuration.
	 * @param demographicId Oscar patient identifier
	 */
	public static int fetchDocuments(int demographicId, String providerId) {
		
		int newDocumentCount = 0;
		
		try {
		
			IheConfiguration config = IheConfigurationUtil.load();
			
			DemographicDao demographicDao = (DemographicDao) SpringUtils.getBean("demographicDao");
			Demographic patientDemographic = demographicDao.getDemographicById(demographicId);
			
			
			//PersonDemographic patient = new PersonDemographic();
			
			PersonDemographic patient = new PersonDemographic();
			
			for (IheAffinityDomainConfiguration affinityDomainConfig : config.getAffinityDomains())
			{
				XdsCommunicator xds = new XdsCommunicator(affinityDomainConfig);
				
				XdsQuerySpecification query = new XdsQuerySpecification(XdsGuidType.RegistryStoredQuery_FindDocuments);			
	
				// Set the oscar identifier.
				DomainIdentifier patInfo = new DomainIdentifier();
				patInfo.setAssigningAuthority(affinityDomainConfig.getActor(IheActorType.PAT_IDENTITY_X_REF_MGR).getLocalIdentification().getUniqueId());
				patInfo.setRoot(OscarRootId);
				patInfo.setExtension(Integer.toString(demographicId));
				
				patient.addIdentifier(patInfo);
				
	
				
	
				if (patientDemographic.getSex().equals("M")) {
					patient.setGender(Gender.M);
				} else if (patientDemographic.getSex().equals("F")) {
					patient.setGender(Gender.F);
				}
	
				// Set the given name
				NameComponent name = new NameComponent();
				name.setType(PartType.Given);
				name.setValue(patientDemographic.getFirstName());
	
				patient.addName(name);
	
				// Set the family name
				NameComponent familyName = new NameComponent();
				familyName.setType(PartType.Family);
				familyName.setValue(patientDemographic.getLastName());
	
				patient.addName(familyName);
	
				// Set the patient's date of birth.
				int day = Integer.parseInt(patientDemographic.getDateOfBirth());
				int month = Integer.parseInt(patientDemographic.getMonthOfBirth());
				int year = Integer.parseInt(patientDemographic.getYearOfBirth());
	
				Date dateOfBirth = new GregorianCalendar(year, month, day).getTime();
				patient.setDateOfBirth(dateOfBirth);
	
				// Get the Client Registry's patient id (resolve)
				PixCommunicator pixCommunicator = new PixCommunicator(affinityDomainConfig);
				try {
					
					PersonDemographic resolvedPatient = pixCommunicator.resolveIdentifiers(patient);
					query.setPatient(resolvedPatient);
					
				} catch (CommunicationsException e) {
					MiscUtils.getLogger().debug("Communications Exception: " + e.getMessage());
					throw e;
				}
				
					
				DocumentMetaData[] foundDocuments = xds.find(query);
				
	            for (DocumentMetaData documentMetaData : foundDocuments)
	            {
	            	// check the destination of the document (do not get documents that we registered from Oscar)
	            	Object authorInstitutionObject = documentMetaData.getExtendedAttribute("authorInstitution");
	            	boolean authorInstitutionCheck = false;
	            	if (authorInstitutionObject instanceof List<?>) {
	            		authorInstitutionCheck = ((List<String>)authorInstitutionObject).contains(oscarProperties.getProperty("OSCAR_CLINIC_NAME", null));
	            	} else if (authorInstitutionObject instanceof String) {
	            		authorInstitutionCheck = ((String)authorInstitutionObject).equals(oscarProperties.getProperty("OSCAR_CLINIC_NAME", null));
	            	}
	            	
	            	if (authorInstitutionCheck == false) {
	            		// external document
		            	PatientDocument doc = new PatientDocument();
		            	doc.setDemographic_no(demographicId);
		    			doc.setAffinityDomain(affinityDomainConfig.getName());
		    			doc.setDownloaded(false);
		    			doc.setTitle(documentMetaData.getTitle());
		    			doc.setMimetype(documentMetaData.getMimeType());
		    			doc.setCreationTime(documentMetaData.getCreationTime().getTime());
		    			doc.setUniqueDocumentId(documentMetaData.getDocumentUniqueId().getExtension());
	    				doc.setRepositoryUniqueId(((XdsDocumentMetaData)documentMetaData).getRepositoryUniqueId());
	    				doc.setAuthor(((List<String>)documentMetaData.getExtendedAttribute("authorPerson")).get(0));
		    			
	    				// if the document DOESNT exist, persist it, otherwise do nothing
	    				if (!patientDocumentDao.documentExists(doc.getUniqueDocumentId(), doc.getRepositoryUniqueId())) {
	    					patientDocumentDao.persist(doc);
	    					newDocumentCount++;
	    				}
	            	}
	            }
	
			}
			
			// if new documents (external from affinity domains) were added to the database
			if (newDocumentCount > 0) {
				// add a tickler notification
				TicklerCreator ticker = new TicklerCreator();
				ticker.createTickler(Integer.toString(demographicId), providerId, "You have new external document(s)");
			}
		
		} catch (CommunicationsException e) {
			MiscUtils.getLogger().debug("Communications Exception: " + e.getMessage());
		} catch (Exception e) {
        	MiscUtils.getLogger().debug("Fetch Documents Exception: " + e.getMessage());
        }
		
		return newDocumentCount;
		
	}
	
}
