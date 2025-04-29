#!/bin/bash

# Start nuBoard in the background
export NUPLAN_DEVKIT_ROOT="/workspace/Diffusion-Planner/nuplan-devkit"
export NUPLAN_DATA_ROOT="/datasets/nuplan"
export NUPLAN_MAPS_ROOT="/datasets/nuplan/maps"
export NUPLAN_EXP_ROOT="/workspace/experiments"
export NUPLAN_DB_FILES="/datasets/nuplan/nuplan-v1.1/splits/val"
export NUPLAN_SIMULATION_ALLOW_ANY_BUILDER=1
export BOKEH_ALLOW_WS_ORIGIN="*"
export BOKEH_ADDR="0.0.0.0"

cd /workspace/Diffusion-Planner/nuplan-devkit
bokeh serve nuplan/planning/nuboard/nuboard.py \
  --port 6599 \
  --address 0.0.0.0 \
  --allow-websocket-origin="*" \
  --args \
  "simulation_path=/workspace/experiments/exp/simulation/closed_loop_nonreactive_agents/diffusion_planner/val14/diffusion_planner_release/model_2025-04-09-17-34-09 \
  scenario_builder=nuplan \
  scenario_builder.db_files=/datasets/nuplan/nuplan-v1.1/splits/val" &

# Start Jupyter
jupyter-notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.allow_origin='*'