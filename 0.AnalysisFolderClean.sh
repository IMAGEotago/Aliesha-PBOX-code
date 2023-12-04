# SET THE PATHS - ADJUST THIS SECTION ONLY

data=/data/kemal206/PBOX_rest_data
scripts=/home/kemal206/PBOX_scripts

# Set Region and Date of previous analysis

region=Amygdala
date=May22

# SPECIFY THE VARIABLES

# Set PPIDs to analyse
subj=(subj001 subj002 subj003 subj004 subj005 subj006 subj007 subj008 subj009 subj010 subj011 subj012 subj013 subj014 subj015 subj016 subj017 subj018 subj019 subj020 subj021 subj022 subj023 subj024 subj025 subj026 subj027 subj028 subj029 subj030 subj031 subj032 subj033 subj034 subj035 subj036 subj037 subj038 subj039 subj040) 

# PPIDs not analysing

# Specify the ROIs
ROI=(LeftBasolateralAmygdala RightBasolateralAmygdala LeftCentromedialAmygdala RightCentromedialAmygdala)

##############

# Check if folder for old analyses exists in the region folder for each subject, otherwise make them 

for x in ${subj[@]}; do 
	
	if [ -d "${data}/${x}/${region}/Old_Analyses" ]
	then
		echo "Directory for Old Analyses for ${region} exists in ${x}"
	else
		echo "Creating directory for Old Analyses for ${region} in ${x}"
		mkdir ${data}/${x}/${region}/Old_Analyses
	fi

	if [ -d "${data}/${x}/${region}/Old_Analyses/${date}" ]
	then
		echo "Directory for ${date} analysis for ${region} exists in ${x}"
	else
		echo "Creating directory for ${region} analysis from ${date} for ${x}"
		mkdir ${data}/${x}/${region}/Old_Analyses/${date}
		
# Move old files from previous analysis to Old_Analyses folder for each subject

		echo "Moving files from previous analysis to old anaysis folder for ${x}"
		
		for y in ${ROI[@]}; do

			mv ${data}/${x}/${region}/${x}_${y}_firstlevel.feat ${data}/${x}/${region}/Old_Analyses/${date}/${x}_${y}_firstlevel.feat
		
		done
		
		mv ${data}/${x}/${region}/${x}_middlelevel.gfeat ${data}/${x}/${region}/Old_Analyses/${date}/${x}_middlelevel.gfeat
		mv ${data}/${x}/${region}/masks ${data}/${x}/${region}/${date}/masks
		mv ${data}/${x}/${region}/timecourses ${data}/${x}/${region}/${date}/timecourses
		
		echo "Files from ${region} analysis from ${date} moved for ${x}"

	fi

done

# List contents of region folders to ensure they are empty

for x in ${subj[@]}; do 
	
	echo "Files in ${region} directory for ${x}"
	ls ${data}/${x}/${region} 

done

#######################################

# RENAMING DESIGN FILES

# Check if folder for old analyses exists in the region folder for the design files, otherwise make them 

if [ -d "${scripts}/design_files/${region}/Old_Analyses" ]
then
	echo "Directory for Old Analyses for ${region} exists in design files directory"
else
	echo "Creating directory for Old Analyses for ${region} in design files directory"
	mkdir ${scripts}/design_files/${region}/Old_Analyses
fi

if [ -d "${scripts}/design_files/${region}/Old_Analyses/${date}" ]
then
	echo "Directory for ${date} analysis for ${region} exists in design files directory"
else
  echo "Creating directory for design files for ${region} analysis from ${date}"
	mkdir ${scripts}/design_files/${region}/Old_Analyses/${date}
fi

# Move old files from previous analyses to Old_Analyses folder for each subject

echo "Moving design files from previous analyses to old anaysis folder"

for x in ${subj[@]}; do 
	
	for y in ${ROI[@]}; do
		mv ${scripts}/design_files/${region}/PBOX_${x}_${y}_firstlevel.fsf ${scripts}/design_files/${region}/Old_Analyses/${date}/PBOX_${x}_${y}_firstlevel.fsf
	done
	
	mv ${scripts}/design_files/${region}/PBOX_${x}_middlelevel.fsf ${scripts}/design_files/${region}/Old_Analyses/${date}/PBOX_${x}_middlelevel.fsf
	
	echo "Files from ${region} analysis from ${date} moved for ${x}"

done 

#########################################

