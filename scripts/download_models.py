import os,json,pathlib,urllib.request,subprocess
root=pathlib.Path("/workspace/ComfyUI/models")
data=json.loads(pathlib.Path("/opt/template/config/models.json").read_text())
for kind,entry in data.items():
    if kind=="wan_remote":
        if os.getenv("WAN_MODELS","true").lower()!="true": continue
        with urllib.request.urlopen(entry,timeout=40) as resp: entries=json.load(resp)
    else:
        if os.getenv("QWEN_MODELS","true").lower()!="true": continue
        entries=entry
    for sub,urls in entries.items():
        folder=root/sub;folder.mkdir(parents=True,exist_ok=True)
        for url in urls:
            name=url.split("?")[0].split("/")[-1]; dest=folder/name
            if dest.exists() and dest.stat().st_size>1024:
                print("SKIP",dest,flush=True); continue
            print("GET",url,flush=True)
            subprocess.run(["aria2c","-x","8","-s","8","-k","1M","-c","--file-allocation=none","--max-tries=8","--retry-wait=10","-d",str(folder),"-o",name,url],check=True)
            if not dest.exists() or dest.stat().st_size<1024: raise RuntimeError("Incomplete model "+str(dest))
