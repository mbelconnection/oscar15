package org.oscarehr.ws.rest.conversion;

import org.oscarehr.PMmodule.model.Program;
import org.oscarehr.ws.rest.to.model.ProgramTo1;


public class ProgramConverter extends AbstractConverter<Program, ProgramTo1> {
		
//		private static Logger logger = Logger.getLogger(ProgramConverter.class);

		@Override
		public Program getAsDomainObject(ProgramTo1 t) throws ConversionException {
			Program a = new Program();
			a.setId(t.getId());
			a.setName(t.getName());
			return a;
		}
		
		@Override
		public ProgramTo1 getAsTransferObject(Program a) throws ConversionException {
			ProgramTo1 t = new ProgramTo1();
			t.setId(a.getId());
			t.setId(a.getId());
			t.setName(a.getName());
			return t;
		}

}

