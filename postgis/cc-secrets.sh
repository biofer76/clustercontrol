#!/usr/bin/env bash

# Read data from secrets into env variables.

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)

function file_env {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
    echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
    exit 1
  fi
  local val="$def"
  if [ "${!var:-}" ]; then
    val="${!var}"
  elif [ "${!fileVar:-}" ]; then
    val="$(< "${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

file_env 'CC_CMON_PASSWORD'
file_env 'CC_MYSQL_ROOT_PASSWORD'

# Make sure we have a user set up
if [ -z "${POSTGRES_USER}" ]; then
	CC_CMON_PASSWORD=cmon
fi

if [ -z "${CC_MYSQL_ROOT_PASSWORD}" ]; then
	CC_MYSQL_ROOT_PASSWORD=mysql
fi