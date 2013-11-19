#!/bin/bash

dir_servers="servers"

function create_items(){

	n=1

	for i in `ls $dir_servers` 
	do
		items="$items $n $i"
		n=`expr $n + 1`
	done

	create_menu
	connect

}

function create_subitems(){

        n=1
	items=""

        for j in `cat $dir_servers/$server |  awk '{print $1}'` 
	do
		items="$items $n $j"
		n=`expr $n + 1`
        done

        create_menu
	subconnect

}


function create_menu(){

	if menuout=$( dialog --stdout --ok-label "Conectar" --cancel-label "Sair" --menu 'SSH Connect' 0 0 0 $items ) 
	then
		return $menuout
	else
		exit 0
	fi

}

function connect(){

        n=1

        for i in `ls $dir_servers` 
	do
		if [ $n -eq $menuout ] 
		then
			server=$i
			break
        	fi
		n=`expr $n + 1`
	done

	if [ `wc -l $dir_servers/$server | awk '{print $1}'`  -gt 1 ] 
	then
		create_subitems
	else
		cmd_connect item
	fi

}

function subconnect(){

	n=1

	for i in `cat $dir_servers/$server | awk '{print $1}'`
	do
		if [ $n -eq $menuout ] 
		then
			host=$i
			break
		fi
		n=`expr $n + 1`
	done

	cmd_connect subitem

}

function cmd_connect(){

	case $1 in
		item) cmd=`cat $dir_servers/$server` ;;
		subitem) cmd=`cat $dir_servers/$server | grep $host` ;;
	esac

	clear

	client=`echo $cmd | awk '{print $1}'`
	host=`echo $cmd | awk '{print $2}'`
	port=`echo $cmd | awk '{print $4}'`
	user=`echo $cmd | awk '{print $3}'`
	
	echo "Conectando em $server ($client)" ; echo
	
	ssh $host -p $port -l $user || read
	

}

create_items
