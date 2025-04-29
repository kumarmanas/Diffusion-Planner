###################################
# User Configuration Section
###################################
NUPLAN_DATA_PATH="/datasets/nuplan/nuplan-v1.1/splits/train_boston" # nuplan training data path (e.g., "/data/nuplan-v1.1/trainval")
NUPLAN_MAP_PATH="/datasets/nuplan/maps" # nuplan map path (e.g., "/data/nuplan-v1.1/maps")

TRAIN_SET_PATH="/datasets/nuplan/manas/nuplan_processed_data/train_boston" # preprocess training data
###################################
mkdir -p $TRAIN_SET_PATH
python data_process.py \
--data_path $NUPLAN_DATA_PATH \
--map_path $NUPLAN_MAP_PATH \
--save_path $TRAIN_SET_PATH \
--total_scenarios 1000000 \

