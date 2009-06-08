/*
*
* Copyright (c) 2001-2002. Centre for Research on Inner City Health, St. Michael's Hospital, Toronto. All Rights Reserved. *
* This software is published under the GPL GNU General Public License.
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version. *
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details. * * You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *
*
* <OSCAR TEAM>
*
* This software was written for
* Centre for Research on Inner City Health, St. Michael's Hospital,
* Toronto, Ontario, Canada
*/

package org.oscarehr.PMmodule.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.oscarehr.PMmodule.model.Facility;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.oscarehr.PMmodule.dao.BedDAO;
import org.oscarehr.PMmodule.dao.FacilityDAO;
import org.oscarehr.PMmodule.dao.ProgramDao;
import org.oscarehr.PMmodule.dao.RoomDAO;
import org.oscarehr.PMmodule.exception.DuplicateRoomNameException;
import org.oscarehr.PMmodule.exception.RoomHasActiveBedsException;
import org.oscarehr.PMmodule.model.Bed;
import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.PMmodule.model.Room;
import org.oscarehr.PMmodule.model.RoomDemographic;
import org.oscarehr.PMmodule.model.RoomType;
import org.springframework.beans.factory.annotation.Required;

/**
 * Management of rooms
 */
public class RoomManager {

    private static final Log log = LogFactory.getLog(RoomManager.class);

    private RoomDAO roomDAO;
    private BedManager bedManager;
    private RoomDemographicManager roomDemographicManager;
    private ProgramDao programDao;
    private BedDAO bedDAO;
    private FacilityDAO facilityDAO;

    /**
     * Get room
     *
     * @param roomId
     *            room identifier
     * @return room
     */
    public Room getRoom(Integer roomId) {
        if (roomId == null) {
            throw new IllegalArgumentException("roomId must not be null");
        }

        Room room = roomDAO.getRoom(roomId);
        if(room==null) return room;
        return room;
    }

    /**
     * Get rooms
     * @return list of rooms
     */
    public Room[] getRooms(Integer facilityId) {
        Room[] rooms = roomDAO.getRooms(facilityId, null, null);
        return rooms;
    }

    public Room[] getRooms(Integer facilityId, Integer programId, Boolean active) {
        Room[] rooms = roomDAO.getRooms(facilityId, programId, active);
        return rooms;
    }

    /**
     * Get rooms
     * @return array of rooms that have beds assigned to them.
     */
    
    public Room[] getRooms(Integer[][] roomsOccupancy) {
    	if(roomsOccupancy == null || roomsOccupancy[0] == null  ||  roomsOccupancy[0].length == 0){
    		return null;
    	}
    	Room[] rooms = new Room[roomsOccupancy.length];
    	for(int i=0; i < rooms.length; i++){
    		rooms[i] = getRoom(roomsOccupancy[i][0]);
    		//not needed, this is the number of beds assigned to this particular room -- which has its occupancy limit
    		//rooms[i].setOccupancy(roomsOccupancy[1][i]);
    	}
        return rooms;
    }
    
    /**
     * Get assigned rooms
     * @return list of assigned rooms
     */
    public Room[] getAssignedBedRooms(Integer facilityId, Integer programId, Boolean active) {
        Room[] rooms = roomDAO.getAssignedBedRooms(facilityId, programId, active);
        return rooms;
    }
   
    /**
     * Get assigned rooms
     * @return list of assigned rooms
     */
    public Room[] getAssignedBedRooms(Integer facilityId) {
        Room[] rooms = roomDAO.getAssignedBedRooms(facilityId, null, null);
        return rooms;
    }
    
    
    /**
     * Get rooms that are not full
     * @return list of unfilled rooms
     */
    public Room[] getUnfilledRoomIds(Bed[] beds) {
    	
    	List roomList = new ArrayList();
    	Integer[][] roomIdAndOccupancy = calculateOccupancyAsNumOfBedsAssignedToRoom(beds);

		if(roomIdAndOccupancy == null){
			return null;
		}
    	Room[] rooms = getRooms(roomIdAndOccupancy); 
  	    //rooms subject to condition: roomCapacity - occupancy > 0
        for(int i=0; rooms != null  &&  i < rooms.length; i++){
    		
    	  for(int j=0; j < roomIdAndOccupancy.length; j++){
    			
    			if(  rooms[i].getId().intValue() == roomIdAndOccupancy[j][0].intValue() ){
   			
    				if( rooms[i].getCapacity().intValue() - roomIdAndOccupancy[j][1].intValue() >= 0 ){
    					roomList.add(rooms[i]);
    				}
    			}
    		}
    	}

    	if(roomList == null || roomList.isEmpty()){
    		return null;
    	}
        return (Room[]) roomList.toArray(new Room[roomList.size()]);
    }
    
	/**
	 * Get available rooms
	 *
	 * @param facilityId
	 * @param programId
	 * @param active           
	 * @return list of available bed rooms that have client assigned less than 
	 * 			its occupancy limit. 
	 */
    //@SuppressWarnings("unchecked")
    public Room[] getAvailableRooms(Integer facilityId, Integer programId, Boolean active, 
    		String demographicNo, boolean emptyRoomRequired) {
    	//rooms of particular facilityId, programId, active=1, (assignedBed=1 or assignedBed=0) 
    	Room[] rooms = roomDAO.getAvailableRooms(facilityId, programId, active);
    	
    	List roomDemograhics = null;
    	List availableRooms = new ArrayList();
		
    	//get rooms that are not full or clients can still be assigned to these rooms
    	//however, even if room capacity is reached, the rooms will still be added if that particular client is 
    	//assigned to that particular room.
    	for(int i=0; rooms != null  &&  i < rooms.length; i++){
    	  int totalClientsInRoom = 0;
		  //get  all (multiple) demographicNo  from  table  'room_demographic' via rooms[i].id	
		  roomDemograhics = roomDemographicManager.getRoomDemographicByRoom(rooms[i].getId());
		  List roomDemographicNumbers = new ArrayList();
				
		  if(emptyRoomRequired){
		    if(roomDemograhics.size() == 0 && rooms[i].getAssignedBed().intValue()==0) availableRooms.add(rooms[i]);
		  }else{
			if(roomDemograhics != null){
			  totalClientsInRoom = roomDemograhics.size();
			  for(int j=0; j < roomDemograhics.size(); j++){
				roomDemographicNumbers.add(((RoomDemographic)roomDemograhics.get(j)).getId().getDemographicNo() );
			  }
			}
			//if client is assigned to this room, even if capacity reached, still display room in dropdown
			if(isClientAssignedToThisRoom(Integer.valueOf(demographicNo), roomDemographicNumbers)){
			  availableRooms.add(rooms[i]);
			}else{
			  //if client not in this room, only display room only if the room have available bed(AssignedBed=Y)
			  if(rooms[i].getAssignedBed().intValue()==1){
				Bed[] availableBeds = bedManager.getAvailableBedsByRoom(rooms[i].getId());
				if(availableBeds.length>0) availableRooms.add(rooms[i]);
			  }else{
				if (roomDemograhics.size() == 0) {
				//v1.3 if a no-bed room is occupied, no body can take it regardless capacity.
//				if(rooms[i].getCapacity().intValue() -  totalClientsInRoom > 0){
				  availableRooms.add(rooms[i]);
				}
			  }
			}
		  }
    			
    	}
    	
		log.debug("getAvailableRooms(): availableRooms = " + availableRooms.size());
		return (Room[]) availableRooms.toArray(new Room[availableRooms.size()]);
	}

    private boolean isClientAssignedToThisRoom(Integer demographicNo, List demographicNumbers){
     	try{
    		if(demographicNo == null  ||  demographicNumbers == null){
    			return false;
    		}
    		for(int i=0; i < demographicNumbers.size(); i++ ){
	    		if(demographicNo.intValue() == ((Integer)demographicNumbers.get(i)).intValue()){
	    			return true;
	    		}
    		}
    		return false;
    	}catch(Exception ex){
    		return false;
    	}
    }
    
    /**
     * Calculate occupancy number as number of beds assigned to each room when 
     * assignedBed attribute is set to 'Y'
     * @param beds
     */
    public Integer[][] calculateOccupancyAsNumOfBedsAssignedToRoom(Bed[] beds){
    	if(beds == null){
    		return null;
    	}
    	List roomIdKeys = new ArrayList();
    	List roomIdCounts = new ArrayList();
    	Integer[][] roomsOccupancy = null;
    	int count = 1;
    	int roomIdKey = -1;

    	Integer[] roomIds = new Integer[beds.length];
    	for(int i=0; i < beds.length; i++){
    		roomIds[i] = beds[i].getRoomId();
    	}
    	
    	Arrays.sort( roomIds  );  
		
		//adding up repeated roomIds as the number of beds assigned to this roomId
    	if(roomIds != null  &&  roomIds.length > 0){
    		roomIdKey = roomIds[0].intValue();
    		for( int i=1; i < roomIds.length; i++  ){
    			if( roomIdKey  == roomIds[i].intValue() ){
    				count++;
    			}else{
     				if(i > 0){
    					roomIdKeys.add(new Integer(roomIdKey));
    				}
    				roomIdCounts.add( new Integer( count ) );
    				count = 1;
    			}
    			roomIdKey = roomIds[i].intValue();
    			if( i == roomIds.length - 1 ){
    				roomIdKeys.add(new Integer(roomIdKey));
    				roomIdCounts.add( new Integer( count ) );
    			}
    		}
    	}
    	
    	if(roomIdKeys == null  ||  roomIdKeys.size() <= 0){
    		return null;
    	}
    	
    	
    	roomsOccupancy = new Integer[roomIdKeys.size()][2];
    	for(int i=0; i < roomsOccupancy.length; i++){
    		
	        roomsOccupancy[i][0] = (Integer)roomIdKeys.get(i);
	        roomsOccupancy[i][1] = (Integer)roomIdCounts.get(i);
    	}
    	
    	return roomsOccupancy;
    }
    
    
    public boolean isAssignedBed( String roomId, Room[] rooms ){
    	
    	if(roomId == null  ||  rooms == null){
    		return false;
    	}
    	for(int i=0; i < rooms.length; i++){
			try{
	    		if( Integer.parseInt(roomId) == rooms[i].getId().intValue()  &&  rooms[i].getAssignedBed().intValue() == 1){
	    			return true;
	    		}else if( Integer.parseInt(roomId) == rooms[i].getId().intValue()  &&  rooms[i].getAssignedBed().intValue() == 0){
	    			return false;
	    		}
			}catch(NumberFormatException nfex){
				return false;
			}
    	}
    	return false;
    }
    
    /**
	 * Test to see whether room is assigned with beds - return true or
	 * assigned with no beds yet - return false
     * @param roomId
     */
    public boolean isRoomAssignedWithBeds(Integer roomId){
    	if(roomId == null){
    		return false;
    	}
    	Bed[] beds = bedDAO.getBedsByRoom(roomId, Boolean.TRUE);
    	if(beds != null  &&  beds.length > 0){
    		return true;
    	}
    	return false;
    }
    
    /**
	 * Used by AdmissionManager during processDischarge()  to  delete discharged
     * program-related room/bed reservation records
     * @param demographicNo
     * @param programId
     */
    public boolean isRoomOfDischargeProgramAssignedToClient(Integer demographicNo, Integer programId){
    	/*
    	 *(1)admission.clientId ===[table:room_demographic]===>>  roomDemographic.roomId
		 *(2)roomDemographic.roomId ===[table:room]===>>   room.programId
		 *(3)Compare  admission.programId  with  room.programId
		 *   - if true -->  return true -- delete  roomDemographic record
		 *   - if false -->  return false -- do nothing
    	 */
    	
    	if(demographicNo == null  ||  programId == null){
    		return false;
    	}
    	Program program=programDao.getProgram(programId);
    	RoomDemographic roomDemographic = roomDemographicManager.getRoomDemographicByDemographic(demographicNo);
    	if(roomDemographic != null){
 	    	Room room = getRoom(roomDemographic.getId().getRoomId());
	    	if(room != null  &&  programId.intValue() == room.getProgramId().intValue()){
	    		return true;
	    	}
    	}
    	return false;
    }
    
    /**
     * Get room types
     *
     * @return list of room types
     */
    public RoomType[] getRoomTypes() {
        return roomDAO.getRoomTypes();
    }
    public RoomType[] getActiveRoomTypes() {
        return roomDAO.getActiveRoomTypes();
    }

    /**
     * Add new rooms
     *
     * @param numRooms
     *            number of rooms
     * @throws RoomHasActiveBedsException
     *             room has active beds
     */
/*    
    public void addRooms(Integer facilityId, int numRooms) throws RoomHasActiveBedsException {
        if (numRooms < 1) {
            throw new IllegalArgumentException("numRooms must be greater than or equal to 1");
        }

        RoomType defaultRoomType = getDefaultRoomType();

        for (int i = 0; i < numRooms; i++) {
            saveRoom(Room.create(facilityId, defaultRoomType));
        }
    }
*/
    /**
     * Save rooms
     *
     * @param rooms
     *            rooms to create or update
     * @throws RoomHasActiveBedsException
     *             room has active beds
     */
    public void saveRooms(Room[] rooms) throws RoomHasActiveBedsException, DuplicateRoomNameException {
        if (rooms == null) {
            throw new IllegalArgumentException("rooms must not be null");
        }
        //Check for duplicate room names.
        for (int i = 0; i < rooms.length; i++) {
        	String name1 = rooms[i].getName().trim();
        	for (int j = 0; j < rooms.length; j++) {
        		String name2 = rooms[j].getName().trim();
        		if ((i != j) && (name1.length()>0 && name1.equalsIgnoreCase(name2) && rooms[i].getProgramId().equals(rooms[j].getProgramId()))) {
        			throw new DuplicateRoomNameException(rooms[i].getName());
//        			return;
        		}
        	}
        }
//        for (Room room : rooms) {
        for (int i=0;i<rooms.length;i++) {
        	Room room = rooms[i];
        	if(room.getName().trim().length()>0) // room without name will not be saved 
        		saveRoom(room);
        }
    }

    public void saveRoom(Room room) throws IllegalStateException{
        validate(room);
        roomDAO.saveRoom(room);
    }

    public void deleteRoom(Room room) throws RoomHasActiveBedsException {
        roomDAO.deleteRoom(room);
    }

    RoomType getDefaultRoomType() {
//        for (RoomType roomType : getRoomTypes()) {
    	RoomType[] roomTypes = getRoomTypes();
        for (int i=0;i< roomTypes.length;i++) {
        	RoomType roomType = roomTypes[i]; 
            if (roomType.isDefault()) {
                return roomType;
            }
        }

        throw new IllegalStateException("no default room type");

//        return null;
    }

    void validate(Room room){
        if (room == null) {
            throw new IllegalStateException("room must not be null");
        }

        validateRoomType(room.getRoomTypeId());
        validateProgram(room.getProgramId());
        if(room.isActive()==false){
          /* allow deactive a room as long as no occupancy 
        	Bed[] bed=bedDAO.getBedsByRoom(room.getId(), Boolean.TRUE);
           	if(bed!=null && bed.length>0)
        	  	throw new IllegalStateException("room can not be inactive with active beds");
          */
          List rdm = roomDemographicManager.getRoomDemographicByRoom(room.getId());
          if(rdm.size()>0)
        	  throw new IllegalStateException("room can not be inactive with client occupied");
        }  
    }
/*
    void validateRoom(Room room) throws RoomHasActiveBedsException {
        Integer roomId = room.getId();

        if (roomId != null) {
            if (!roomDAO.roomExists(roomId)) {
                throw new IllegalStateException("no room with id : " + roomId);
            }
        }
    }
*/
    void validateRoomType(Integer roomTypeId) {
        if (!roomDAO.roomTypeExists(roomTypeId)) {
            throw new IllegalStateException("no room type with id : " + roomTypeId);
        }
    }

    void validateProgram(Integer programId) {
        if (programId != null && !programDao.isTypeOf(programId,Program.BED_TYPE)) {
            throw new IllegalStateException("no bed program with id : " + programId);
        }
    }

    //@Required
    public void setFacilityDAO(FacilityDAO facilityDAO) {
        this.facilityDAO = facilityDAO;
    }

    //@Required
    public void setRoomDAO(RoomDAO roomDAO) {
        this.roomDAO = roomDAO;
    }

    //@Required
    public void setProgramDao(ProgramDao programDao) {
        this.programDao = programDao;
    }

    //@Required
    public void setBedDAO(BedDAO bedDAO) {
        this.bedDAO = bedDAO;
    }

    //@Required
    public void setBedManager(BedManager bedManager) {
        this.bedManager = bedManager;
    }

    //@Required
    public void setRoomDemographicManager(RoomDemographicManager roomDemographicManager) {
        this.roomDemographicManager = roomDemographicManager;
    }
    
}