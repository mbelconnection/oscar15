package org.oscarehr.common.model;

import java.util.Date;

import org.joda.time.DateTime;
import org.joda.time.Interval;

public class Stay {

	private Interval interval;

	public Stay(Date admission, Date discharge, Date start, Date end) {
		DateTime admissionDateTime = admission.after(start) ? new DateTime(admission) : new DateTime(start);
		DateTime dischargeDateTime = (discharge != null) ? new DateTime(discharge) : new DateTime(end);
		
		try {
			interval = new Interval(admissionDateTime, dischargeDateTime);
		} catch (IllegalArgumentException e) {
			System.err.println("admission: " + admissionDateTime + " discharge: " + dischargeDateTime);
			throw e;
		}
	}
	
	public Interval getInterval() {
		return interval;
	}

}
