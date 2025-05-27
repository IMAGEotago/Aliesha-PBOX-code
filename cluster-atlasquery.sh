#!/bin/bash

homedirectory=/data/kemal206/PBOX_rest_data
analysis="Amygdala_STAIT-001"
lowercontrasts="11"
highercontrasts="10"

###

higherlevelgfeat=$homedirectory/$analysis.gfeat
clustertable=$homedirectory/${analysis}_clustertable.csv
clusterregions=$homedirectory/${analysis}_clusterregions.txt

### EXTRACTING INFORMATION FOR CLUSTER TABLE ###

echo "COPE,ZSTAT,ClusterIndex,Voxels,P,X,Y,Z" > $clustertable  # clears output file if already exists

for COPE in $(seq 1 "$lowercontrasts"); do

    for ZSTAT in $(seq 1 "$highercontrasts"); do

    # Construct the input file path for the current COPE
    input_file=${higherlevelgfeat}/cope$COPE.feat/cluster_zstat${ZSTAT}_std.txt

    # Check if the input file exists
    if [ ! -f "$input_file" ]; then
        echo "Input file $input_file does not exist. Skipping"
        continue
    fi 

    echo "Processing $input_file ..."

    # Extract the appropriate columns and prepend the COPE number and Contrast
    awk -v cope="$COPE" -v zstat="$ZSTAT" 'NR > 1 {print cope "," zstat "," $1 "," $2 "," $3 "," $6 "," $7 "," $8}' "$input_file" >> $clustertable

    done

done

echo "Output has been saved to $clustertable."

### RUNNING ATLAS QUERY ON CLUSTER IMAGES ###

echo "atlasquery results for each cluster of all the contrasts with significant results" > $clusterregions  # clears output file if already exists

while IFS=, read -r COPE ZSTAT ClusterIndex Voxels P X Y Z; do

    # Skip the header row
    if [ "$COPE" == "COPE" ]; then
        continue
    fi

    input_file=${higherlevelgfeat}/cope$COPE.feat/cluster_mask_zstat$ZSTAT
    cluster_file=${input_file}_$ClusterIndex

    # Check if the input file exists
    if [ ! -f "$input_file".nii.gz ]; then
        echo "Input file $input_file does not exist. Skipping"
        continue
    fi 

    # Create mask for Cluster Index value
    fslmaths "$input_file".nii.gz -thr "$ClusterIndex" -uthr "$ClusterIndex" -bin "$cluster_file".nii.gz
    wait

    # Run atlas query to list subcortical regions 
    {
        echo "COPE$COPE ZSTAT$ZSTAT CLUSTER$ClusterIndex : Harvard-Oxford Subcortical Structural Atlas" 
        atlasquery -a "Harvard-Oxford Subcortical Structural Atlas" -m "$cluster_file".nii.gz 
	echo ""

        # Run atlas query to list cortical regions
        echo "COPE$COPE ZSTAT$ZSTAT CLUSTER$ClusterIndex : Harvard-Oxford Cortical Structural Atlas - Left Hemisphere" 
        fslmaths "$cluster_file".nii.gz -roi 90 180 1 -1 1 -1 0 1 "$cluster_file"_left.nii.gz 
        wait
        atlasquery -a "Harvard-Oxford Cortical Structural Atlas" -m "$cluster_file"_left.nii.gz 
	echo ""

        echo "COPE$COPE ZSTAT$ZSTAT CLUSTER$ClusterIndex : Harvard-Oxford Cortical Structural Atlas - Right Hemisphere" 
        fslmaths "$cluster_file".nii.gz -roi 1 90 1 -1 1 -1 0 1 "$cluster_file"_right.nii.gz
        wait
        atlasquery -a "Harvard-Oxford Cortical Structural Atlas" -m "$cluster_file"_right.nii.gz 
        echo ""

    } >> $clusterregions
    
done < $clustertable

echo "Output has been saved to $clusterregions."
