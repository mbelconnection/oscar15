package org.oscarehr.PMmodule.web.admin;

import org.oscarehr.PMmodule.web.BaseAction;
import org.oscarehr.PMmodule.model.Room;
import org.oscarehr.PMmodule.model.Bed;
import org.oscarehr.PMmodule.exception.RoomHasActiveBedsException;
import org.oscarehr.PMmodule.exception.BedReservedException;
import org.apache.struts.action.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Responsible for managing beds
 */
public class BedManagerAction extends BaseAction {

    private static final String FORWARD_MANAGE = "manage";


    public ActionForward unspecified(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        return manage(mapping, form, request, response);
    }

    private ActionForward manage(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {

        BedManagerForm bForm = (BedManagerForm) form;

        bForm.setRooms(roomManager.getRooms());
        bForm.setRoomTypes(roomManager.getRoomTypes());
        bForm.setNumRooms(1);
        bForm.setBeds(bedManager.getBeds());
        bForm.setBedTypes(bedManager.getBedTypes());
        bForm.setNumBeds(1);
        bForm.setPrograms(programManager.getBedPrograms());

        return mapping.findForward(FORWARD_MANAGE);
    }


	public ActionForward saveRooms(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        BedManagerForm bForm = (BedManagerForm) form;

		Room[] rooms = bForm.getRooms();

		// detect check box false
		for (int i = 0; i < rooms.length; i++) {
	        if (request.getParameter("rooms[" + i + "].active") == null) {
	        	rooms[i].setActive(false);
	        }
        }

		try {
	        roomManager.saveRooms(rooms);
        } catch (RoomHasActiveBedsException e) {
    		ActionMessages messages = new ActionMessages();
    		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("room.active.beds.error", e.getMessage()));
    		saveMessages(request, messages);
        }

        return manage(mapping, form, request, response);
    }

	public ActionForward saveBeds(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        BedManagerForm bForm = (BedManagerForm) form;

		Bed[] beds = bForm.getBeds();

		for (int i = 0; i < beds.length; i++) {
	        if (request.getParameter("beds[" + i + "].active") == null) {
	        	beds[i].setActive(false);
	        }
        }

		try {
	        bedManager.saveBeds(beds);
        } catch (BedReservedException e) {
			ActionMessages messages = new ActionMessages();
			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("bed.reserved.error", e.getMessage()));
			saveMessages(request, messages);
        }

		return manage(mapping, form, request, response);
    }

	public ActionForward addRooms(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        BedManagerForm bForm = (BedManagerForm) form;
		Integer numRooms = bForm.getNumRooms();

		if (numRooms!= null && numRooms > 0) {
			try {
	            roomManager.addRooms(numRooms);
            } catch (RoomHasActiveBedsException e) {
        		ActionMessages messages = new ActionMessages();
        		messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("room.active.beds.error", e.getMessage()));
        		saveMessages(request, messages);
            }
		}

        return manage(mapping, form, request, response);
    }

	public ActionForward addBeds(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        BedManagerForm bForm = (BedManagerForm) form;
		Integer numBeds = bForm.getNumBeds();

		if (numBeds != null && numBeds > 0) {
			try {
	            bedManager.addBeds(numBeds);
            } catch (BedReservedException e) {
    			ActionMessages messages = new ActionMessages();
    			messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("bed.reserved.error", e.getMessage()));
    			saveMessages(request, messages);
            }
		}

        return manage(mapping, form, request, response);
    }
}
