"""Package local sources into one offline HTML; never writes full-version files."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
html = (ROOT / "index.html").read_text()
css = (ROOT / "style.css").read_text()
html = html.replace('<link rel="stylesheet" href="style.css">', f"<style>{css}</style>")
for source in ["vendor/three-0.160.1.min.js", "model.js", "app.js"]:
    code = (ROOT / source).read_text().replace("</script", "<\\/script")
    html = html.replace(f'<script src="{source}"></script>', f"<script>\n{code}\n</script>")
html = html.replace('href="../', 'href="').replace('href="README.md">外形依据', 'href="realistic/README.md">外形依据')
target = ROOT.parent / "beanlens-realistic-h1.html"
target.write_text(html)
sources = ["index.html", "style.css", "model.js", "app.js", "vendor/three-0.160.1.min.js"]
record = {
    "date": "2026-10-21", "revision": "H1-appearance-1",
    "geometry_reference": "../design-h1.json", "appearance": "reconstructed_not_vendor_cad",
    "geometry_reference_sha256": hashlib.sha256((ROOT.parent / "design-h1.json").read_bytes()).hexdigest(),
    "three_version": "0.160.1", "network_required": False,
    "artifact": target.name,
    "sources_sha256": {name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest() for name in sources},
    "artifact_sha256": hashlib.sha256(target.read_bytes()).hexdigest(),
}
(ROOT / "build-record.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
print(f"已生成 {target.name}（{target.stat().st_size:,} 字节，本地离线）")
