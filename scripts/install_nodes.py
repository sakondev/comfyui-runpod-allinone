import json,subprocess,pathlib
root=pathlib.Path("/opt/ComfyUI/custom_nodes")
root.mkdir(parents=True,exist_ok=True)
for url in json.loads(pathlib.Path("/opt/template/config/nodes.json").read_text()):
    target=root/url.rsplit("/",1)[-1].removesuffix(".git")
    if not target.exists(): subprocess.run(["git","clone","--depth","1",url,str(target)],check=True)
    req=target/"requirements.txt"
    if req.exists(): subprocess.run(["pip","install","-r",str(req)],check=True)
