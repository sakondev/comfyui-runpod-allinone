import pathlib,urllib.request
dest=pathlib.Path("/workspace/ComfyUI/user/default/workflows/BFS-Head-Swap-Qwen2.1.json")
dest.parent.mkdir(parents=True,exist_ok=True)
if not dest.exists():
    try: urllib.request.urlretrieve("https://huggingface.co/Alissonerdx/BFS-Best-Face-Swap/resolve/main/workflows/Head%20Swap%20V1%20Qwen%202.1%20Workflow.json",dest)
    except Exception as exc: print("workflow download warning:",exc)
