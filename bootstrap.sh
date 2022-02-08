#!/bin/bash
DBHOST=${DBHOST}
DBNAME=${DBNAME}
UNAME=${UNAME}
PW=${PW}
PORT=${PORT}


cat << EOF 
<?php
namespace sys;

interface IConnectInfo
{
	const HOST = "$DBHOST";
	const UNAME = "$UNAME";
	const PW = "$PW";
	const PORT = "$PORT";
	
	const DBNAME = "$DBNAME";
	
	public static function doConnect($test);
}
?>
EOF