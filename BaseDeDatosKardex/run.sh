#!/usr/bin/env bash
set -e
mkdir -p lib out
if [ ! -f lib/postgresql-42.7.3.jar ]; then
  echo "Descargando driver PostgreSQL..."
  if command -v curl >/dev/null 2>&1; then
    curl -L -o lib/postgresql-42.7.3.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar
  elif command -v wget >/dev/null 2>&1; then
    wget -O lib/postgresql-42.7.3.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar
  else
    echo "No se encontró curl ni wget. Descarga el driver manualmente y colócalo en lib/"
    exit 1
  fi
fi
echo "Compilando..."
javac -cp "lib/postgresql-42.7.3.jar:." src/BaseDeDatosKardex.java -d out
echo "Ejecutando..."
java -cp "out:lib/postgresql-42.7.3.jar" BaseDeDatosKardex
