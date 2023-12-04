# SET THE PATHS - ADJUST THIS SECTION ONLY

data=/data/kemal206/PBOX_rest_data
scripts=/home/kemal206/PBOX_scripts
reference=/home/kemal206/PBOX_reference
region=Amygdala

# SPECIFY THE VARIABLES

# Set PPIDs to analyse
subj=(subj001 subj002 subj003 subj004 subj005 subj006 subj007 subj008 subj009 subj010 subj011 subj012 subj013 subj014 subj015 subj016 subj017 subj018 subj019 subj020 subj021 subj022 subj023 subj024 subj025 subj026 subj027 subj028 subj029 subj030 subj031 subj032 subj033 subj034 subj035 subj036 subj037 subj038 subj039 subj040)

# Specify the ROIs
if [[ ${region} == "Amygdala" ]]; then
	ROI=(LeftBasolateralAmygdala RightBasolateralAmygdala LeftCentromedialAmygdala RightCentromedialAmygdala)
elif [[ ${region} == "Insula" ]]; then
	ROI=(LeftAnteriorInsula RightAnteriorInsula)
else 
	echo "${region} areas are not included in script"
	exit
fi

# Specify the template
template=${scripts}/PBOX_middlelevel_${region}_template.fsf


####################################

# Check if region folder in design files exists
if [ -d "${scripts}/design_files/${region}" ]
then
	echo "Directory for ${region} exists in design files directory"
else 
	echo "Creating directory for ${region} in design files directory"
	mkdir ${scripts}/design_files/${region}
fi

for x in ${subj[@]}; do 

	# Check if registration folder exists
	for y in ${ROI[@]}; do 
		if [ -d "${data}/${x}/${region}/${x}_${y}_firstlevel.feat/reg" ]
		then
			echo "Registration directory for ${x} exists in ${x}_${y}_firstlevel.feat directory"
		else 
			echo "Copying registration directory for ${x} into ${x}_${y}_firstlevel.feat directory"
			cp -r ${data}/${x}/${x}_reg.feat/reg ${data}/${x}/${region}/${x}_${y}_firstlevel.feat/reg
			sleep 30
		fi
	done
	 

	# Run middle-level FEAT analysis - change for regions 
	echo "Creating the middle level analysis for ${x}"
	if [[ ${region} == "Amygdala" ]]; then
		cat ${template} | sed s:CMLEFT:${data}/${x}/${region}/${x}_LeftCentromedialAmygdala_firstlevel.feat:g \
				| sed s:CMRIGHT:${data}/${x}/${region}/${x}_RightCentromedialAmygdala_firstlevel.feat:g \
				| sed s:BLLEFT:${data}/${x}/${region}/${x}_LeftBasolateralAmygdala_firstlevel.feat:g \
				| sed s:BLRIGHT:${data}/${x}/${region}/${x}_RightBasolateralAmygdala_firstlevel.feat:g \
				| sed s:OUTPUTDIR:${data}/${x}/${region}/${x}_middlelevel_${region}.gfeat:g > \
				${scripts}/design_files/${region}/PBOX_${x}_middlelevel_${region}.fsf
	elif [[ ${region} == "Insula" ]]; then
		cat ${template} | sed s:LEFT:${data}/${x}/${region}/${x}_LeftAnteriorInsula_firstlevel.feat:g \
				| sed s:RIGHT:${data}/${x}/${region}/${x}_RightAnteriorInsula_firstlevel.feat:g \
				| sed s:OUTPUTDIR:${data}/${x}/${region}/${x}_middlelevel_${region}.gfeat:g > \
				${scripts}/design_files/${region}/PBOX_${x}_middlelevel_${region}.fsf
	else 
		echo "${region} areas are not included in script"
		exit
	fi

done

echo "Middle level FEAT analyses created for all subjects"

echo "Would you like to run the feat analyses? [yes or no]" 
read response

if [[ ${response} == "yes" ]]; then
	echo "Running middle level FEAT analyses"

	for x in ${subj[@]}; do 
		feat ${scripts}/design_files/${region}/PBOX_${x}_middlelevel_${region}.fsf &
		echo "Running middle level FEAT analysis for ${x}"
		sleep 10
	done
else 
	echo "stopping script"
	exit
fi
