#!/bin/bash
# filepath: /mnt/disk1/kumar/manas_plan/flow_plan/Diffusion-Planner/process_all_train.sh

###################################
# User Configuration Section
###################################
NUPLAN_BASE_PATH="/datasets/nuplan/nuplan-v1.1/splits/train_pittsburgh"
NUPLAN_MAP_PATH="/datasets/nuplan/maps"
TRAIN_SET_PATH="/datasets/nuplan/manas/nuplan_processed_data/train_pittsburgh"
MAX_TOTAL_SCENARIOS=1000000
###################################

# Create output directory if it doesn't exist
mkdir -p $TRAIN_SET_PATH

# Find all train_* folders
TRAIN_FOLDERS=$(ls -d $NUPLAN_BASE_PATH/train_*)
FOLDER_COUNT=$(echo "$TRAIN_FOLDERS" | wc -l)

# Calculate scenarios per folder (with slight buffer for rounding)
SCENARIOS_PER_FOLDER=$((MAX_TOTAL_SCENARIOS / FOLDER_COUNT))
echo "Processing $FOLDER_COUNT train folders with $SCENARIOS_PER_FOLDER scenarios per folder"

# Initialize counter for total scenarios processed
TOTAL_PROCESSED=0

# Process each folder
for FOLDER in $TRAIN_FOLDERS; do
    FOLDER_NAME=$(basename $FOLDER)
    echo "Processing folder $FOLDER_NAME..."
    
    # Calculate remaining scenarios
    REMAINING=$((MAX_TOTAL_SCENARIOS - TOTAL_PROCESSED))
    if [ $REMAINING -le 0 ]; then
        echo "Reached maximum total scenarios limit. Skipping remaining folders."
        break
    fi
    
    # Determine how many scenarios to process from this folder
    THIS_FOLDER_SCENARIOS=$SCENARIOS_PER_FOLDER
    if [ $THIS_FOLDER_SCENARIOS -gt $REMAINING ]; then
        THIS_FOLDER_SCENARIOS=$REMAINING
    fi
    
    # Create folder-specific output directory
    FOLDER_OUTPUT="$TRAIN_SET_PATH/$FOLDER_NAME"
    mkdir -p $FOLDER_OUTPUT
    
    echo "Processing up to $THIS_FOLDER_SCENARIOS scenarios from $FOLDER_NAME"
    
    # Run data processing for this folder
    python data_process.py \
        --data_path $FOLDER \
        --map_path $NUPLAN_MAP_PATH \
        --save_path $FOLDER_OUTPUT \
        --total_scenarios $THIS_FOLDER_SCENARIOS
    
    # Get actual number of scenarios processed for this folder
    # Assuming your script prints "Total number of scenarios: X" - adjust if needed
    PROCESSED_COUNT=$(grep "Total number of scenarios:" $FOLDER_OUTPUT/log.txt | awk '{print $5}' || echo 0)
    TOTAL_PROCESSED=$((TOTAL_PROCESSED + PROCESSED_COUNT))
    
    echo "Processed $PROCESSED_COUNT scenarios from $FOLDER_NAME. Total so far: $TOTAL_PROCESSED"
done

echo "Processing complete. Total scenarios processed: $TOTAL_PROCESSED"