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

package org.oscarehr.PMmodule.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.oscarehr.PMmodule.exception.BedReservedException;
import org.oscarehr.PMmodule.model.Bed;
import org.oscarehr.PMmodule.model.BedType;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class BedDAO extends HibernateDaoSupport {

    private static final Logger log = LogManager.getLogger(BedDAO.class);

    public boolean bedExists(Integer bedId) {

        return (((Long) getHibernateTemplate().iterate("select count(*) from Bed where id = " + bedId).next()).intValue() == 1);
    }

    public boolean bedTypeExists(Integer bedTypeId) {
        boolean exists = (((Long) getHibernateTemplate().iterate("select count(*) from BedType where id = " + bedTypeId).next()).intValue() == 1);
        log.debug("bedTypeExists: " + exists);

        return exists;
    }

    public Bed getBed(Integer bedId) {
        Bed bed = (Bed) getHibernateTemplate().get(Bed.class, bedId);
        log.debug("getBed: id " + bedId);

        return bed;
    }

    public BedType getBedType(Integer bedTypeId) {
        BedType bedType = (BedType) getHibernateTemplate().get(BedType.class, bedTypeId);
        log.debug("getBedType: id " + bedTypeId);

        return bedType;
    }

    public Bed[] getBedsByRoom(Integer roomId, Boolean active) {
        String query = getBedsQuery(null, roomId, active);
        Object[] values = getBedsValues(null, roomId, active);
        List beds = getBeds(query, values);
        log.debug("getBedsByRoom: size " + beds.size());

        return (Bed[]) beds.toArray(new Bed[beds.size()]);
    }

    public BedType[] getBedTypes() {
        List bedTypes = getHibernateTemplate().find("from BedType bt");
        log.debug("getRooms: size: " + bedTypes.size());

        return (BedType[]) bedTypes.toArray(new BedType[bedTypes.size()]);
    }
    public BedType[] getActiveBedTypes() {
        List bedTypes = getHibernateTemplate().find("from BedType bt where bt.active=?", Boolean.TRUE);
        log.debug("getRooms: size: " + bedTypes.size());

        return (BedType[]) bedTypes.toArray(new BedType[bedTypes.size()]);
    }

    public void saveBed(Bed bed) {
        getHibernateTemplate().saveOrUpdate(bed);
        getHibernateTemplate().flush();
        getHibernateTemplate().refresh(bed);

        log.debug("saveBed: id " + bed.getId());
    }


    public void deleteBed(Bed bed) {
        log.debug("deleteBed: id " + bed.getId());

        getHibernateTemplate().delete(bed);
    }


    String getBedsQuery(Integer facilityId, Integer roomId, Boolean active) {
        StringBuffer queryBuilder = new StringBuffer("from Bed b");

        queryBuilder.append(" where ");

        boolean andClause = false;

        if (roomId!= null) {
            if (andClause) queryBuilder.append(" and "); else andClause = true;
            queryBuilder.append("b.roomId = ?");
            andClause = true;
        }

        if (active != null) {
            if (andClause) queryBuilder.append(" and ");
            queryBuilder.append("b.active = ?");
        }
        queryBuilder.append(" order by b.name");
        return queryBuilder.toString();
    }

    
    Object[] getBedsValues(Integer facilityId, Integer roomId, Boolean active) {
        List values = new ArrayList();

        if (facilityId != null) {
            values.add(facilityId);
        }

        if (roomId != null) {
            values.add(roomId);
        }

        if (active != null) {
            values.add(active);
        }

        return (Object[]) values.toArray(new Object[values.size()]);
    }

    List getBeds(String query, Object[] values) {
        return (values.length > 0) ? getHibernateTemplate().find(query, values) : getHibernateTemplate().find(query);
    }

}