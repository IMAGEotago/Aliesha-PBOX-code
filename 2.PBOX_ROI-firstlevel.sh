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

# Specify the masks
atlas_masks=/home/kemal206/PBOX_reference/${region}_Masks

# Specify the template
template=${scripts}/PBOX_firstlevel_template.fsf

#########################################

# Check if region folder in design files exists
if [ -d "${scripts}/design_files/${region}" ]
then
	echo "Directory for ${region} exists in design files directory"
else 
	echo "Creating directory for ${region} in design files directory"
	mkdir ${scripts}/design_files/${region}
fi

# Check if region folder in subject data folders exists
for x in ${subj[@]}; do
	if [ -d "${data}/${x}/${region}" ]
	then
		echo "Directory for ${region} exists for ${x}"
	else 
		echo "Creating directory for ${region} in ${x}"
		mkdir ${data}/${x}/${region}
	fi
done

# Invert overall warp
for x in ${subj[@]}; do

	if [ -f "${data}/${x}/${x}_reg.feat/reg/standard2highres_warp.nii.gz" ]
	then 
		echo "Inverted warp for ${x} exists"
	else
		echo "Inverting warp for ${x}"
		invwarp -w ${data}/${x}/${x}_reg.feat/reg/highres2standard_warp -o ${data}/${x}/${x}_reg.feat/reg/standard2highres_warp -r ${data}/${x}/${x}_reg.feat/reg/highres
	fi

done

echo "Overall warps inverted for all subjects"

echo "Would you like to continue? [yes or no]" 
read response

if [[ ${response} == "yes" ]]; then
	echo "continuing script"
else 
	echo "stopping script"
	exit
fi

# Mask Binary Neurosynth Map with Binary ROI Masks
echo "Beginning to mask Neurosynth map for each ROI"
for y in ${ROI[@]}; do 
	
	if [ -f "${atlas_masks}/${y}MaskNeuro.nii.gz" ]
	then
		echo "Neurosynth map already masked with ${y}"
	else 
		echo "Masking Neurosynth map with ${y}"
		fslmaths ${reference}/NeurosynthAnxietyUniformityTestBin -mas ${atlas_masks}/${y}MaskThrBin ${atlas_masks}/${y}MaskNeuro
	fi

done

echo "Would you like to continue? [yes or no]" 
read response

if [[ ${response} == "yes" ]]; then
	echo "continuing script"
else 
	echo "stopping script"
	exit
fi

# Apply overall inverted transformation to ROI NeuroSynth Masks for each subject and threshold and binarise the transformed mask
for x in ${subj[@]}; do
	
	if [ -d "${data}/${x}/${region}/masks" ]
	then
		echo "Directory for ${region} masks exists for ${x}"
		ls ${data}/${x}/${region}/masks
		
	else
		mkdir ${data}/${x}/${region}/masks
		echo "Applying inverted warps to ROI masks for ${x}"
		for y in ${ROI[@]}; do
			applywarp -i ${atlas_masks}/${y}MaskNeuro -o ${data}/${x}/${region}/masks/${y}MaskFunc -r ${data}/${x}/${x}_reg.feat/reg/example_func -w ${data}/${x}/${x}_reg.feat/reg/standard2highres_warp --postmat=${data}/${x}/${x}_reg.feat/reg/highres2example_func.mat
		done
		echo "Thresholding and binarising the transformed ROI masks for ${x}"
		for y in ${ROI[@]}; do 
			fslmaths ${data}/${x}/${region}/masks/${y}MaskFunc -thr 0.5 -bin ${data}/${x}/${region}/masks/${y}MaskFuncBin
		done
	fi
done

echo "Check if a 'MaskFuncBin' exists for each ROI for each subject"
echo "Would you like to continue? [yes or no]" 
read response

if [[ ${response} == "yes" ]]; then
	echo "continuing script"
else 
	echo "stopping script"
	exit
fi

	
# Calculate the average timecourse within the mask
echo "Beginning to calculate average timecourse within the ROI masks for each subject"
for x in ${subj[@]}; do 
	
	if [ -d "${data}/${x}/${region}/timecourses" ]
	then
		echo "Directory for ${region} timecourses exists for ${x}"
		ls ${data}/${x}/${region}/timecourses
	else
		mkdir ${data}/${x}/${region}/timecourses
		echo "Calculating the average timecourse with the ROI masks for ${x}"
		for y in ${ROI[@]}; do 
			fslmeants -i ${data}/${x}/${x}_rest_clean.nii.gz -o ${data}/${x}/${region}/timecourses/${y}Timecourse.txt -m ${data}/${x}/${region}/masks/${y}MaskFuncBin
		done
	fi
done

echo "Would you like to continue? [yes or no]" 
read response

if [[ ${response} == "yes" ]]; then
	echo "continuing script"
else 
	echo "stopping script"
	exit
fi

# Run first-level FEAT analysis for each ROI for each subject
echo "Beginning to run the first level analysis for each subject using the template"
for x in ${subj[@]}; do
	echo "Running the first level analysis for ${x}"
	for y in ${ROI[@]}; do
		echo "${y}"
		cat ${template} | sed s:INPUTDATAFILE:${data}/${x}/${x}_rest_clean:g \
			| sed s:ROITIMESERIES:${data}/${x}/${region}/timecourses/${y}Timecourse.txt:g \
			| sed s:OUTPUTDIR:${data}/${x}/${region}/${x}_${y}_firstlevel.feat:g > \
			${scripts}/design_files/${region}/PBOX_${x}_${y}_firstlevel.fsf
		feat ${scripts}/design_files/${region}/PBOX_${x}_${y}_firstlevel.fsf &
		sleep 10
	done
done
