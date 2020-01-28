@echo off

set BASEDIR=%~dp0

REM setup the JVM
IF "x%JAVA_HOME%" == "x" (
  SET JAVA=java
  ECHO JAVA_HOME is not set. Unexpected results may occur.
  ECHO Set JAVA_HOME to the directory of your local JDK to avoid this message.
) ELSE (
  IF NOT EXIST "%JAVA_HOME%" (
    ECHO JAVA_HOME "%JAVA_HOME%" path doesn't exist
    GOTO :EOF
  ) ELSE (
    IF NOT EXIST "%JAVA_HOME%\bin\java.exe" (
      ECHO "%JAVA_HOME%\bin\java.exe" does not exist
      GOTO :EOF
    )
    ECHO Setting JAVA property to "%JAVA_HOME%\bin\java"
    SET JAVA="%JAVA_HOME%\bin\java"
  )
)


REM set environment parameters
SET webappsPath=%BASEDIR%/../lib/webapps/
SET restPath=%BASEDIR%/../lib/rest/
SET classPath=%BASEDIR%/../lib/db/


REM inspect arguments
:Loop
IF [%~1]==[] GOTO Continue

IF [%~1]==[--webapps] (
  SET classPath=%webappsPath%,%classPath%
  ECHO WebApps enabled
) 

IF [%~1]==[--rest] (
  SET classPath=%restPath%,%classPath%
  ECHO REST API enabled
)

SHIFT
GOTO Loop
:Continue

ECHO classpath: %classPath%


REM start the application
call %JAVA% -Dloader.path="%classPath%" -jar "%BASEDIR%/../lib/camunda-rest-distro.jar" --spring.config.location=file:"%BASEDIR%"/../config/application.yml
