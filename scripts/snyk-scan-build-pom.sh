#!/bin/bash

rm pom.xml
touch pom.xml

IN_DEPENDENCIES=false
IN_EXCLUSIONS=false
IN_PARENT=false
IN_MODULES=false
DEPS=""

PARENT_ARTIFACT=$(mvn -f ../pom.xml -q -Dexec.executable=echo -Dexec.args='${project.artifactId}' --non-recursive exec:exec 2>/dev/null)
PARENT_VERSION=$(mvn -f ../pom.xml -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive exec:exec 2>/dev/null)

while IFS= read -r ln; do

  #Reorder this
  [[ "$ln" == *"</dependencies>"* ]] && IN_DEPENDENCIES=false
  [[ "$ln" == *"<exclusions>"* ]] && IN_EXCLUSIONS=true
  [[ "$ln" == *"<parent>"* ]] && IN_PARENT=true
  [[ "$ln" == *"<modules>"* ]] && IN_MODULES=true

  $IN_DEPENDENCIES && ! $IN_EXCLUSIONS && DEPS+="${ln:4}"$'\n'
  
  if [[ $IN_PARENT = false && $IN_MODULES = false && $IN_DEPENDENCIES = false ]]
  then
    if [[ "$ln" == *"<artifactId>$PARENT_ARTIFACT</artifactId>"* ]]
    then
      echo "    <artifactId>snyc-scan-project</artifactId>" >> pom.xml
    elif [[ "$ln" == *"</project>"* ]]
    then    
      echo "<dependencies>" >> pom.xml
      echo $DEPS >> pom.xml
      echo "</dependencies>" >> pom.xml
      echo "</project>" >> pom.xml
    elif [[ "$ln" != *"<dependencies>"* && "$ln" != *"</dependencies>"* ]]
    then
      echo "$ln" >> pom.xml
    fi
  fi

  [[ "$ln" == *"</exclusions>"* ]] && IN_EXCLUSIONS=false
  [[ "$ln" == *"<dependencies>"* ]] && IN_DEPENDENCIES=true
  [[ "$ln" == *"</modules>"* ]] && IN_MODULES=false
  if [[ "$ln" == *"</parent>"* ]]
  then
    IN_PARENT=false
    echo "    <parent>" >> pom.xml
    echo "        <groupId>org.entando</groupId>" >> pom.xml
    echo "        <artifactId>$PARENT_ARTIFACT</artifactId>" >> pom.xml
    echo "        <relativePath>../pom.xml</relativePath>" >> pom.xml
    echo "        <version>$PARENT_VERSION</version>" >> pom.xml
    echo "    </parent>" >> pom.xml
   fi

done < "../pom.xml"