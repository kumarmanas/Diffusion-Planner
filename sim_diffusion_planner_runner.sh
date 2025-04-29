export CUDA_VISIBLE_DEVICES=2,3,4,5,6,7
export NCCL_ASYNC_ERROR_HANDLING=1
export NCCL_TIMEOUT_SECONDS=3600
export HYDRA_FULL_ERROR=1

###################################
# User Configuration Section
###################################
# Set environment variables
export NUPLAN_DEVKIT_ROOT="/workspace/nuplan-devkit"  # nuplan-devkit absolute path (e.g., "/home/user/nuplan-devkit")
export NUPLAN_DATA_ROOT="/datasets"  # nuplan dataset absolute path (e.g. "/data")
export NUPLAN_MAPS_ROOT="/datasets/nuplan/maps" # nuplan maps absolute path (e.g. "/data/nuplan-v1.1/maps")
export NUPLAN_EXP_ROOT="/workspace/experiments" # nuplan experiment absolute path (e.g. "/data/nuplan-v1.1/exp")
export NUPLAN_DB_FILES="/datasets/nuplan/nuplan-v1.1/splits/val"
# Dataset split to use
# Options: 
#   - "test14-random"
#   - "test14-hard"
#   - "val14"
SPLIT="val14"  # e.g., "val14"
echo "NUPLAN_DATA_ROOT is set to: $NUPLAN_DATA_ROOT"
# Challenge type
# Options: 
#   - "closed_loop_nonreactive_agents"
#   - "closed_loop_reactive_agents"
CHALLENGE="closed_loop_nonreactive_agents"  # e.g., "closed_loop_nonreactive_agents"
###################################


BRANCH_NAME=diffusion_planner_release
# ARGS_FILE="/workspace/Diffusion-Planner/checkpoints/args.json"
# CKPT_FILE="/workspace/Diffusion-Planner/checkpoints/model.pth"
ARGS_FILE="/workspace/Diffusion-Planner/training_log/diffusion-planner-training/2025-04-21-19\:29\:16/args.json"
CKPT_FILE="/workspace/Diffusion-Planner/training_log/diffusion-planner-training/2025-04-21-19\:29\:16/model_epoch_500_trainloss_0.0383.pth"
if [ "$SPLIT" == "val14" ]; then
    SCENARIO_BUILDER="nuplan"
else
    SCENARIO_BUILDER="nuplan_challenge"
fi
echo "Processing $CKPT_FILE..."
FILENAME=$(basename "$CKPT_FILE")
FILENAME_WITHOUT_EXTENSION="${FILENAME%.*}"

PLANNER=diffusion_planner

echo "Using database files from: $NUPLAN_DB_FILES"
ls -l $NUPLAN_DB_FILES/*.db | wc -l

python $NUPLAN_DEVKIT_ROOT/nuplan/planning/script/run_simulation.py \
    +simulation=$CHALLENGE \
    planner=$PLANNER \
    planner.diffusion_planner.config.args_file=$ARGS_FILE \
    planner.diffusion_planner.ckpt_path=$CKPT_FILE \
    scenario_builder=$SCENARIO_BUILDER \
    scenario_builder.db_files=$NUPLAN_DB_FILES \
    scenario_filter=$SPLIT \
    +simulation.splitter=nuplan \
    experiment_uid=$PLANNER/$SPLIT/$BRANCH_NAME/${FILENAME_WITHOUT_EXTENSION}_$(date "+%Y-%m-%d-%H-%M-%S") \
    verbose=true \
    worker=ray_distributed \
    worker.threads_per_node=128 \
    distributed_mode='SINGLE_NODE' \
    number_of_gpus_allocated_per_simulation=0.15 \
    enable_simulation_progress_bar=true \
    hydra.searchpath="[file:///workspace/nuplan-devkit/nuplan/planning/script/config, file:///workspace/nuplan-devkit/nuplan/planning/script/experiments, pkg://diffusion_planner.config.planner, pkg://diffusion_planner.config.scenario_filter, pkg://diffusion_planner.config, pkg://nuplan.planning.script.config.common, pkg://nuplan.planning.script.experiments]"