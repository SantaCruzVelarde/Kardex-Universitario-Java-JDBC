\
    @echo off
    setlocal
    if not exist lib (
      mkdir lib
    )
    if not exist lib\postgresql-42.7.3.jar (
      echo Descargando driver PostgreSQL...
      powershell -Command "Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar' -OutFile 'lib\postgresql-42.7.3.jar'"
      if NOT exist lib\postgresql-42.7.3.jar (
        echo Error: no se pudo descargar el driver. Descargalo manualmente desde Maven Central y ponlo en la carpeta lib\.
        pause
        exit /b 1
      )
    )
    echo Compilando...
    javac -cp "lib\postgresql-42.7.3.jar;." src\BaseDeDatosKardex.java -d out
    if %ERRORLEVEL% NEQ 0 (
      echo Compilacion fallida.
      pause
      exit /b 1
    )
    echo Ejecutando...
    java -cp "out;lib\postgresql-42.7.3.jar" BaseDeDatosKardex
    pause
