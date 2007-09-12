/*
 * 
 * Copyright (c) 2001-2002. Department of Family Medicine, McMaster University. All Rights Reserved. *
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
 * This software was written for the 
 * Department of Family Medicine 
 * McMaster Unviersity 
 * Hamilton 
 * Ontario, Canada 
 */
package oscar.billing.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import org.oscarehr.util.DbConnectionFilter;

import oscar.billing.model.Appointment;
import oscar.billing.model.Demographic;
import oscar.billing.model.Diagnostico;
import oscar.billing.model.ProcedimentoRealizado;
import oscar.billing.model.Provider;
import oscar.oscarDB.DBHandler;
import oscar.util.DAO;
import oscar.util.DateUtils;
import oscar.util.FieldTypes;
import oscar.util.SqlUtils;


public class AppointmentDAO extends DAO {
    public AppointmentDAO(Properties pvar) throws SQLException {
        super(pvar);
    }

    public void billing(Appointment app) throws SQLException {
        String sqlProc;
        String sqlDiag;
		String sqlApp;

        sqlProc = "insert into cad_procedimento_realizado (appointment_no, co_procedimento, dt_realizacao) values (?, ?, ?)";
        sqlDiag = "insert into cad_diagnostico (appointment_no, co_cid) values (?, ?)";
        sqlApp = "update appointment set billing = 'P' where appointment_no = ?";

        Connection c=DbConnectionFilter.getThreadLocalDbConnection();
        PreparedStatement pstmProc = null;
        PreparedStatement pstmDiag = null;
		PreparedStatement pstmApp = null;
        try {
            c.setAutoCommit(false);
            pstmProc = c.prepareStatement(sqlProc);
            pstmDiag = c.prepareStatement(sqlDiag);
            pstmApp = c.prepareStatement(sqlApp);

            unBilling(app, c);

            for (int i = 0; i < app.getProcedimentoRealizado().size(); i++) {
                ProcedimentoRealizado pr = (ProcedimentoRealizado) app.getProcedimentoRealizado()
                                                                      .get(i);

                //appoitment_no
                SqlUtils.fillPreparedStatement(pstmProc, 1,
                    new Long(pr.getAppointment().getAppointmentNo()),
                    FieldTypes.LONG);
                SqlUtils.fillPreparedStatement(pstmProc, 2,
                    new Long(pr.getCadProcedimentos().getCoProcedimento()),
                    FieldTypes.LONG);
                SqlUtils.fillPreparedStatement(pstmProc, 3,
                    DateUtils.formatDate(DateUtils.getDate(pr.getDtRealizacao()),
                        "dd/MM/yyyy"), FieldTypes.DATE);
                pstmProc.execute();
            }

            for (int i = 0; i < app.getDiagnostico().size(); i++) {
                Diagnostico diag = (Diagnostico) app.getDiagnostico().get(i);

                //appoitment_no
                SqlUtils.fillPreparedStatement(pstmDiag, 1,
                    new Long(diag.getAppointment().getAppointmentNo()),
                    FieldTypes.LONG);
                SqlUtils.fillPreparedStatement(pstmDiag, 2,
                    diag.getCadCid().getCoCid(), FieldTypes.CHAR);
                pstmDiag.execute();
            }
            
			SqlUtils.fillPreparedStatement(pstmApp, 1,
				String.valueOf(app.getAppointmentNo()), FieldTypes.LONG);
            pstmApp.execute();

            c.commit();
        } catch (Exception e) {
            c.rollback();
            e.printStackTrace();
            throw new SQLException(e.toString());
        } finally {
            SqlUtils.closeResources(c, pstmProc, null);
            SqlUtils.closeResources(pstmDiag, null);
            SqlUtils.closeResources(pstmApp, null);
        }
    }

    public void unBilling(Appointment app) throws SQLException {
        String sqlProc;
        String sqlDiag;

        sqlProc = "delete from cad_procedimento_realizado where appointment_no = ?";
        sqlDiag = "delete from cad_diagnostico where appointment_no = ?";

        Connection c=DbConnectionFilter.getThreadLocalDbConnection();
        PreparedStatement pstmProc = null;
        PreparedStatement pstmDiag = null;
        try {
            c.setAutoCommit(false);
            pstmProc = c.prepareStatement(sqlProc);
            pstmDiag = c.prepareStatement(sqlDiag);

            SqlUtils.fillPreparedStatement(pstmProc, 1,
                new Long(app.getAppointmentNo()), FieldTypes.LONG);
            pstmProc.execute();

            SqlUtils.fillPreparedStatement(pstmDiag, 1,
                new Long(app.getAppointmentNo()), FieldTypes.LONG);
            pstmDiag.execute();

            c.commit();
        } catch (Exception e) {
            c.rollback();
            e.printStackTrace();
            throw new SQLException(e.toString());
        } finally {
            SqlUtils.closeResources(c, pstmDiag, null);
            SqlUtils.closeResources(pstmProc, null);
        }
    }

    public void unBilling(Appointment app, Connection c)
        throws SQLException {
        String sqlProc;
        String sqlDiag;

        sqlProc = "delete from cad_procedimento_realizado where appointment_no = ?";
        sqlDiag = "delete from cad_diagnostico where appointment_no = ?";

        PreparedStatement pstmProc = c.prepareStatement(sqlProc);
        PreparedStatement pstmDiag = c.prepareStatement(sqlDiag);

        try {
            SqlUtils.fillPreparedStatement(pstmProc, 1,
                new Long(app.getAppointmentNo()), FieldTypes.LONG);
            pstmProc.execute();

            SqlUtils.fillPreparedStatement(pstmDiag, 1,
                new Long(app.getAppointmentNo()), FieldTypes.LONG);
            pstmDiag.execute();
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException(e.toString());
        } finally {
            pstmDiag.close();
            pstmProc.close();
        }
    }

    public Appointment retrieve(String id) throws SQLException {
        Appointment appointment = new Appointment();
        String sql =
            "select app.appointment_no, app.provider_no, prov.first_name, prov.last_name, app.demographic_no, dem.first_name, dem.last_name, app.name, app.reason, app.appointment_date " +
            "from appointment app, provider prov, demographic dem " +
            "where app.provider_no = prov.provider_no and " +
            "app.demographic_no = dem.demographic_no and " +
            "app.appointment_no = " + id;

        System.out.println("sql = " + sql);
        
        DBHandler db = getDb();

        try {
            ResultSet rs = db.GetSQL(sql);

            if (rs.next()) {
                appointment.setAppointmentNo(rs.getLong(1));
                appointment.getProvider().setProviderNo(rs.getString(2));
                appointment.getProvider().setFirstName(rs.getString(3));
                appointment.getProvider().setLastName(rs.getString(4));
                appointment.getDemographic().setDemographicNo(rs.getLong(5));
                appointment.getDemographic().setFirstName(rs.getString(6));
                appointment.getDemographic().setLastName(rs.getString(7));
                appointment.setName(rs.getString(8));
                appointment.setReason(rs.getString(9));
				appointment.setAppointmentDate(rs.getDate(10));
            }
        } finally {
            db.CloseConn();
        }

        return appointment;
    }

    public ArrayList listFatDoctor(String type, Provider provider)
        throws SQLException {
        ArrayList list = new ArrayList();
        String sql =
            "select a.appointment_no, a.appointment_date, a.provider_no, b.last_name, " +
            "b.first_name, a.demographic_no, c.last_name, c.first_name " +
            "from appointment a, provider b, demographic c " +
            "where a.provider_no = b.provider_no and " +
            "a.demographic_no = c.demographic_no ";

        if (type.equals(Appointment.AGENDADO)) {
            sql = sql + " and a.billing = '" + Appointment.AGENDADO + "'";
        } else if (type.equals(Appointment.FATURADO)) {
			sql = sql + " and a.billing = '" + Appointment.FATURADO + "'";
        } else if (type.equals(Appointment.PENDENTE)) {
            sql = sql + " and a.billing is null";
        }
        
        if (provider != null && !provider.getProviderNo().trim().equals("0")) {
			sql = sql + " and a.provider_no = " +  provider.getProviderNo().trim();
        }

        sql = sql + " order by a.appointment_date desc";

        DBHandler db = getDb();

        try {
            ResultSet rs = db.GetSQL(sql);

            while (rs.next()) {
            	Appointment app = new Appointment();
            	app.setAppointmentNo(rs.getLong(1));
            	app.setAppointmentDate(rs.getDate(2));
            	app.getProvider().setProviderNo(rs.getString(3));
            	app.getProvider().setLastName(rs.getString(4));
            	app.getProvider().setFirstName(rs.getString(5));
				app.getDemographic().setDemographicNo(rs.getLong(6));
				app.getDemographic().setLastName(rs.getString(7));
				app.getDemographic().setFirstName(rs.getString(8));
				
				list.add(app);            	
            }
        } finally {
            db.CloseConn();
        }

        return list;
    }

	public ArrayList listFatPatiente(Demographic demographic)
		throws SQLException {
		ArrayList list = new ArrayList();
		String sql =
			"select a.appointment_no, a.appointment_date, a.provider_no, b.last_name, " +
			"b.first_name, a.billing " +
			"from appointment a, provider b, demographic c " +
			"where a.provider_no = b.provider_no and " +
			"a.demographic_no = c.demographic_no and " +
			"a.demographic_no = " + demographic.getDemographicNo() + " and " +
			"a.billing is not null " +
			"order by a.appointment_date desc";

		DBHandler db = getDb();

		try {
			ResultSet rs = db.GetSQL(sql);

			while (rs.next()) {
				Appointment app = new Appointment();
				app.setAppointmentNo(rs.getLong(1));
				app.setAppointmentDate(rs.getDate(2));
				app.getProvider().setProviderNo(rs.getString(3));
				app.getProvider().setLastName(rs.getString(4));
				app.getProvider().setFirstName(rs.getString(5));
				app.setBilling(rs.getString(6));
				
				list.add(app);            	
			}
		} finally {
			db.CloseConn();
		}

		return list;
	}
}
