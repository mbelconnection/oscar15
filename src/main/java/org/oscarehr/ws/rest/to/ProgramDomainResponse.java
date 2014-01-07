package org.oscarehr.ws.rest.to;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSeeAlso;

import org.oscarehr.ws.rest.to.model.ProgramTo1;


@XmlRootElement
@XmlSeeAlso({ProgramTo1.class})
public class ProgramDomainResponse extends AbstractSearchResponse<ProgramTo1> {

    private static final long serialVersionUID = 1L;

	@Override
	@XmlElement(name="programs", type = ProgramTo1.class)
	@XmlElementWrapper(name="content")
    public List<ProgramTo1> getContent() {
	    return super.getContent();
    }
	
	private int currentProgramId = 0;

	public int getCurrentProgramId() {
		return currentProgramId;
	}

	public void setCurrentProgramId(int currentProgramId) {
		this.currentProgramId = currentProgramId;
	}
	
	

}