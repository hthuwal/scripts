if [ "$1" == "" ]
then
	count=0;
else
	count=$1;
fi

if [ ! -d "out" ]
then
	mkdir out
fi

for hc in *
do 	
	if [ -f "$hc" ]
	then
		foo=$hc
		l=${#foo};

		for (( i=0; i<$l; i++ )); 
		do
		  aadi=${foo:$i:1} ## ${foo:$i:$j} = returns the string foo from $i and $j characters ahead including ith character 	  
		  
		  if [ "$aadi" == "." ]
		  then
		  	
		  	extension=${foo:$i:l-$i} 

		  	if [ "$extension" != ".sh" ]
		  	then
			  	count=`expr $count + 1`
			  	if [ $count -lt 10 ]
				then 
					name="0"$count;
				else
					name=$count;
				fi
			  	name=$name$extension;
			  	echo $name;
				cp $foo "out/"$name 
			fi
		  fi
		done
	fi
done