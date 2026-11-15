# NULL HUNTER 遊戲選單：在本機開一個小網站，讓瀏覽器能載入 Godot／Unity 網頁版。
# 由「啟動選單.bat」呼叫；關掉這個視窗就會停止。
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 8765
$prefix = "http://localhost:$port/"

$types = @{
  ".html" = "text/html; charset=utf-8"; ".htm" = "text/html; charset=utf-8"
  ".js" = "text/javascript; charset=utf-8"; ".mjs" = "text/javascript; charset=utf-8"
  ".css" = "text/css; charset=utf-8"; ".json" = "application/json; charset=utf-8"
  ".png" = "image/png"; ".jpg" = "image/jpeg"; ".jpeg" = "image/jpeg"; ".gif" = "image/gif"
  ".svg" = "image/svg+xml"; ".ico" = "image/x-icon"; ".webp" = "image/webp"
  ".wasm" = "application/wasm"; ".pck" = "application/octet-stream"; ".data" = "application/octet-stream"
  ".mem" = "application/octet-stream"; ".unityweb" = "application/octet-stream"
  ".ttf" = "font/ttf"; ".otf" = "font/otf"; ".woff" = "font/woff"; ".woff2" = "font/woff2"
  ".mp4" = "video/mp4"; ".webm" = "video/webm"; ".mp3" = "audio/mpeg"; ".ogg" = "audio/ogg"; ".wav" = "audio/wav"
  ".zip" = "application/zip"; ".txt" = "text/plain; charset=utf-8"
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
try { $listener.Start() } catch {
  Write-Host "無法使用連接埠 $port，可能已經開過一次選單。請關掉其他選單視窗再試。" -ForegroundColor Red
  Read-Host "按 Enter 關閉"; exit 1
}
Write-Host "NULL HUNTER 遊戲選單已啟動：$prefix" -ForegroundColor Cyan
Write-Host "瀏覽器會自動打開；展示結束後關掉這個視窗即可。"
Start-Process $prefix

$rootFull = [System.IO.Path]::GetFullPath($root)
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $res = $ctx.Response
  try {
    $rel = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
    if ($rel -eq "") { $rel = "index.html" }
    $path = [System.IO.Path]::GetFullPath((Join-Path $root $rel))
    if (Test-Path $path -PathType Container) { $path = Join-Path $path "index.html" }
    if (-not $path.StartsWith($rootFull) -or -not (Test-Path $path -PathType Leaf)) {
      $res.StatusCode = 404
    } else {
      $name = [System.IO.Path]::GetFileName($path)
      $ext = [System.IO.Path]::GetExtension($path).ToLower()
      # Unity 壓縮檔（.gz／.br）：照原本的類型送出並標示壓縮方式
      if ($ext -eq ".gz" -or $ext -eq ".br") {
        $res.AddHeader("Content-Encoding", $(if ($ext -eq ".gz") { "gzip" } else { "br" }))
        $ext = [System.IO.Path]::GetExtension($name.Substring(0, $name.Length - $ext.Length)).ToLower()
      }
      $res.ContentType = $(if ($types.ContainsKey($ext)) { $types[$ext] } else { "application/octet-stream" })
      # 讓 Godot 網頁版在需要時也能用多執行緒
      $res.AddHeader("Cross-Origin-Opener-Policy", "same-origin")
      $res.AddHeader("Cross-Origin-Embedder-Policy", "require-corp")
      $res.AddHeader("Cross-Origin-Resource-Policy", "same-origin")
      $res.AddHeader("Cache-Control", "no-cache")
      if ($ctx.Request.HttpMethod -eq "HEAD") {
        $res.ContentLength64 = (Get-Item $path).Length
      } else {
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $res.ContentLength64 = $bytes.Length
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
      }
    }
  } catch { $res.StatusCode = 500 }
  finally { $res.Close() }
}
