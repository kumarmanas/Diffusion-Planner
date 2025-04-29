export CUDA_VISIBLE_DEVICES=2,4,5,6,7,3
export NCCL_ASYNC_ERROR_HANDLING=1
export NCCL_TIMEOUT_SECONDS=3600
###################################
# User Configuration Section
###################################
# print(RUN_PYTHON_PATH)
# RUN_PYTHON_PATH="/usr/bin/python" # python path (e.g., "/home/xxx/anaconda3/envs/diffusion_planner/bin/python")
# print(RUN_PYTHON_PATH)
RUN_PYTHON_PATH="/usr/bin/python" # python path (e.g., "/home/xxx/anaconda3/envs/diffusion_planner/bin/python")
echo "Using Python path: $RUN_PYTHON_PATH"
# Set training data path
TRAIN_SET_PATH="/datasets/nuplan/manas/nuplan_processed_data/train" # preprocess data using data_process.sh
TRAIN_SET_LIST_PATH="/workspace/Diffusion-Planner/diffusion_planner_training1.json"
###################################

$RUN_PYTHON_PATH -m torch.distributed.run --nnodes 1 --nproc-per-node 5 --standalone train_predictor.py \
--train_set  $TRAIN_SET_PATH \
--train_set_list  $TRAIN_SET_LIST_PATH \
--resume_model_path "/workspace/Diffusion-Planner/training_log/diffusion-planner-training/2025-04-21-19:29:16" \

