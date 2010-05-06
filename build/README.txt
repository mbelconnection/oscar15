OSCAR McMaster cvs

This folder contains the necessary ant scripts to build the distribution version of the software.


for CVS installs using Tomcat5 rename the buildTomcat5.xml to build.xml
for CVS installs using Tomcat6 rename the buildTomcat6.xml to build.xml


Add this to a netbeans build.xml file for it to build and run.


<target name="-post-compile">
        <echo message="deleting hbm.xml files from src directory." />
            <delete>
                <fileset dir="${build.classes.dir}/src/" includes="**/*.hbm.xml"/>
            </delete>
</target>
    
