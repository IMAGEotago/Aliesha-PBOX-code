# SET THE PATHS - ADJUST THIS SECTION ONLY

data=/data/kemal206/PBOX_rest_data
scripts=/home/kemal206/PBOX_scripts
reference=/home/kemal206/PBOX_reference


# SPECIFY THE VARIABLES

# Specify the brain region of interest
region=Amygdala

# Specify the anxiety measure of interest (STAIT or ASI)
anxiety=AGE

# Specify the template
template=${scripts}/PBOX_higherlevel_${anxiety}_template.fsf


####################################

# Check if region folder in design files exists
if [ -d "${scripts}/design_files/${region}" ]
then
	echo "Directory for ${region} exists in design files directory"
else 
	echo "Creating directory for ${region} in design files directory"
	mkdir ${scripts}/design_files/${region}
fi

# Run higher-level FEAT analysis
echo "Creating the higher-level FEAT set up"
	
cat ${template}	| sed s:INsubj001:${data}/subj001/${region}/subj001_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj002:${data}/subj002/${region}/subj002_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj003:${data}/subj003/${region}/subj003_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj004:${data}/subj004/${region}/subj004_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj005:${data}/subj005/${region}/subj005_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj006:${data}/subj006/${region}/subj006_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj007:${data}/subj007/${region}/subj007_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj008:${data}/subj008/${region}/subj008_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj009:${data}/subj009/${region}/subj009_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj010:${data}/subj010/${region}/subj010_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj011:${data}/subj011/${region}/subj011_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj012:${data}/subj012/${region}/subj012_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj013:${data}/subj013/${region}/subj013_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj014:${data}/subj014/${region}/subj014_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj015:${data}/subj015/${region}/subj015_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj016:${data}/subj016/${region}/subj016_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj017:${data}/subj017/${region}/subj017_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj018:${data}/subj018/${region}/subj018_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj019:${data}/subj019/${region}/subj019_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj020:${data}/subj020/${region}/subj020_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj021:${data}/subj021/${region}/subj021_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj022:${data}/subj022/${region}/subj022_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj023:${data}/subj023/${region}/subj023_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj024:${data}/subj024/${region}/subj024_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj025:${data}/subj025/${region}/subj025_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj026:${data}/subj026/${region}/subj026_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj027:${data}/subj027/${region}/subj027_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj028:${data}/subj028/${region}/subj028_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj029:${data}/subj029/${region}/subj029_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj030:${data}/subj030/${region}/subj030_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj031:${data}/subj031/${region}/subj031_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj032:${data}/subj032/${region}/subj032_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj033:${data}/subj033/${region}/subj033_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj034:${data}/subj034/${region}/subj034_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj035:${data}/subj035/${region}/subj035_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj036:${data}/subj036/${region}/subj036_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj037:${data}/subj037/${region}/subj037_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj038:${data}/subj038/${region}/subj038_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj039:${data}/subj039/${region}/subj039_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:INsubj040:${data}/subj040/${region}/subj040_middlelevel_${region}.gfeat/cope1.feat:g \
		| sed s:OUTPUTDIR:${data}/${region}_${anxiety}.gfeat:g > \
		${scripts}/design_files/${region}/PBOX_${region}_${anxiety}.fsf

echo "Higher-level FEAT analysis set up made for ${region} ${anxiety}"

echo "Would you like to run the feat analysis? [yes or no]" 
read response

if [[ ${response} == "yes" ]]; then
	echo "Higher-level FEAT analysis running for ${region} ${anxiety}"
	feat ${scripts}/design_files/${region}/PBOX_${region}_${anxiety}.fsf &
else 
	echo "stopping script"
	exit
fi
