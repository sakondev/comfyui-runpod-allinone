#!/usr/bin/env bash
set -euo pipefail
mkdir -p /workspace/ComfyUI/{models,input,output,user/default/workflows}
for dir in models input output user; do
  if [ ! -L "/opt/ComfyUI/$dir" ]; then
    if [ -d "/opt/ComfyUI/$dir" ]; then cp -an "/opt/ComfyUI/$dir/." "/workspace/ComfyUI/$dir/" 2>/dev/null || true; rm -r "/opt/ComfyUI/$dir"; fi
    ln -s "/workspace/ComfyUI/$dir" "/opt/ComfyUI/$dir"
  fi
done
if [ "${MODEL_DOWNLOAD_ON_START:-true}" = true ]; then python /opt/template/scripts/download_models.py; fi
python /opt/template/scripts/install_workflows.py
ARGS=(--listen 0.0.0.0 --port 8188)
if [ "${USE_SAGE_ATTENTION:-false}" = true ]; then
  if python -c 'import sageattention' 2>/dev/null; then ARGS+=(--use-sage-attention); else echo "SageAttention missing: fallback to default"; fi
fi
cd /opt/ComfyUI
exec python main.py "${ARGS[@]}"
