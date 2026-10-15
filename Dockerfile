FROM pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime
ENV DEBIAN_FRONTEND=noninteractive PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
RUN apt-get update && apt-get install -y --no-install-recommends git curl aria2 ffmpeg libgl1 libglib2.0-0 && rm -rf /var/lib/apt/lists/*
WORKDIR /opt
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git && pip install -r /opt/ComfyUI/requirements.txt
RUN pip install --no-deps --find-links https://comfy-org.github.io/wheels/sageattention/ 'sageattention==2.2.0+cu128torch2.8'
COPY config/ /opt/template/config/
COPY scripts/ /opt/template/scripts/
RUN python -m pip install 'pip==24.0' requests && python /opt/template/scripts/install_nodes.py
ENV USE_SAGE_ATTENTION=true MODEL_DOWNLOAD_ON_START=true WAN_MODELS=true QWEN_MODELS=true
VOLUME ["/workspace"]
EXPOSE 8188
CMD ["bash","/opt/template/scripts/start.sh"]
