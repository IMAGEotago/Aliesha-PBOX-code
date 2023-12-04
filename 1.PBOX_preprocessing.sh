# SET THE PATHS - ADJUST THIS SECTION ONLY

data=/data/kemal206/PBOX_rest_data
scripts=/home/kemal206/PBOX_scripts
betvalues=${scripts}/PBOX_bet-values.csv

############################################################################################

# SPECIFY THE VARIABLES

# Set PPIDs to analyse
subj=(subj001 subj002 subj003 subj004 subj005 subj006 subj007 subj008 subj009 subj010 subj011 subj012 subj013 subj014 subj015 subj016 subj017 subj018 subj019 subj020 subj021 subj022 subj023 subj024 subj025 subj026 subj027 subj028 subj029 subj030 subj031 subj032 subj033 subj034 subj035 subj036 subj037 subj038 subj039 subj040)

# Specify the template
template=${scripts}/PBOX_reg_template.fsf

############################################################################################

# BET the structural image
echo "Beginning to run BET on the structural image for each subject"
read ${betvalues} | while IFS="," read sub thresh comments; do
	for s in ${sub}; do
		echo "Running BET on structural image for ${s}"
		bet ${data}/${s}/${s}_struct.nii.gz ${data}/${s}/${s}_struct_brain.nii.gz -f ${thresh}
	done
 done

# Run the registrations using the template
echo "Beginning to run the registration for each subject using the template"
for x in ${subj[@]}; do
	echo "Running the registration for ${x}"
	cat ${template} | sed s:INPUTDATAFILE:${data}/${x}/${x}_rest_clean.nii.gz:g \
		| sed s:STRUCT:${data}/${x}/${x}_struct_brain.nii.gz:g \
		| sed s:FSLSTANDARD:/home/fsl-6.0.4/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz:g \
		| sed s:OUTPUTDIR:${data}/${x}/${x}_reg.feat:g > \
		${scripts}/design_files/PBOX_${x}_reg.fsf
	feat ${scripts}/design_files/PBOX_${x}_reg.fsf &
done
