# 重新裁切網站字型：只保留 index.html、report.html、games.js 用到的字，輸出 woff2。
# 網站加了新的中文字之後執行一次（在選單資料夾開 PowerShell）：
#   uv run --with fonttools --with brotli python tools/subset_fonts.py
# 原始字型（.ttf／.otf）保留在 assets/fonts/，網頁只載入裁切後的 .woff2。
from pathlib import Path
from fontTools import subset

root = Path(__file__).resolve().parent.parent
text = "".join((root / f).read_text(encoding="utf-8") for f in ["index.html", "report.html", "games.js"])
# 另外保留英數與常用全形標點，之後小改文字不用每次重裁
text += "".join(chr(c) for c in range(0x20, 0x7F))
text += "，。、；：？！「」『』（）【】《》〈〉—…－～・·＋×÷→←↑↓▶◀▤▦⇩♪✓✗％＃＠＆＊／＼｜　０１２３４５６７８９"
chars = "".join(sorted(set(text) - set("\r\n\t")))

fonts = root / "assets" / "fonts"
for name in ["NullHunterHan-BodyOblique.ttf", "NullHunterHan-DisplayOblique.otf", "NullHunterHUD-Oblique.ttf", "Exo2-BlackItalic.ttf"]:
    src = fonts / name
    out = src.with_suffix(".woff2")
    opts = subset.Options()
    opts.flavor = "woff2"
    opts.layout_features = ["*"]
    font = subset.load_font(str(src), opts)
    sub = subset.Subsetter(opts)
    sub.populate(text=chars)
    sub.subset(font)
    subset.save_font(font, str(out), opts)
    print(f"{name}: {src.stat().st_size // 1024} KB -> {out.stat().st_size // 1024} KB")
print(f"共 {len(chars)} 個字")
