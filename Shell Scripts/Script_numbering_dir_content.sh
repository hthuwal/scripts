if [ "$1" == "" ]   # if no command line argument
then
	count=0;
else  
	count=$1;
fi

# if there is no folder named out then create it
if [ ! -d "out" ]
then
	mkdir out
fi

# for each item in current directory
for hc in *
do 	
	extension=""
	myname=$0; l=${#myname}; l=`expr $l - 2`; myname=${myname:2:l}
	if [ "$hc" != "$myname" ] && [ -f "$hc" ] # if the item is a file and is not this script
	then
		foo=$hc
		l=${#foo};  # l now stores length of the name of the file name

		for (( i=0; i<$l; i++ )); 
		do
		  aadi=${foo:$i:1} ## ${foo:$i:$j} = returns the string foo from $i and $j characters ahead including ith character 	  
		  
		  # TODO script should consider the last . in the name not the first 
		  if [ "$aadi" == "." ]
		  then
		  	
		  	extension=${foo:$i:l-$i} 

		  	# TODO script should not rename itself but every other script should be renamed
		  	count=`expr $count + 1`
		  	if [ $count -lt 10 ]
			then 
				name="0"$count; # if 1st file then name should be 01
			else
				name=$count;
			fi
		  	name=$name$extension;
		  	echo $name;
			cp "$foo" "out/"$name 
		  fi
		done

		# if file had no extension
		if [ "$extension" == "" ]
		then 
			count=`expr $count + 1`
		  	if [ $count -lt 10 ]
			then 
				name="0"$count; # if 1st file then name should be 01
			else
				name=$count;
			fi
			echo $name;
			cp "$foo" "out/"$name 
		fi
	fi
done