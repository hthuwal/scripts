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
	if [ -f "$hc" ]  # if the current item is a file
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
		  	if [ "$extension" != ".sh" ]
		  	then
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
		  fi
		done
	fi
done