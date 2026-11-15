// 選單內容設定：實戰後只要改這個檔案，不用動 index.html。
// web：網頁版的 index.html 路徑（沒有網頁版就寫 null）
// download：Windows 版壓縮檔路徑（還沒有就寫 null）
// video：實機錄影路徑（沒有就寫 null）
// screenshot：遊戲截圖路徑（還沒有就寫 null，先用素材包的預覽圖）
// stats：實戰數據，還沒有就寫 null，畫面會顯示「—」
window.NULL_HUNTER_GAMES = [
  {
    id: "godot",
    name: "Godot",
    version: "4.7.2",
    date: "11/22",
    lead: "管英序",
    language: "GDScript",
    color: "#45E6E1",
    web: "games/godot/index.html",
    download: "downloads/NullHunter_Godot_Windows.zip",
    video: null,
    screenshot: null,
    note: "",
    stats: { modules: null, firstPass: null, exeSize: null, fps: null }
  },
  {
    id: "unity",
    name: "Unity",
    version: "6000.3.10f1",
    date: "11/29",
    lead: "李佳霖",
    language: "C#",
    color: "#FF4FA3",
    web: "games/unity/index.html",
    download: "downloads/NullHunter_Unity_Windows.zip",
    video: null,
    screenshot: null,
    note: "目前是 11/15 預演版：執行檔與 FPS 為預演量測（FPS 被 165Hz 螢幕的垂直同步鎖住），通過模組與首次成功率等 11/29 正式實戰後再填。",
    stats: { modules: null, firstPass: null, exeSize: 195, fps: 165 }
  },
  {
    id: "unreal",
    name: "Unreal",
    version: "5.8.2",
    date: "12/06",
    lead: "林宥宏",
    language: "C++／藍圖",
    color: "#2D8CFF",
    web: null,
    download: "downloads/NullHunter_Unreal_Windows.zip",
    video: "videos/NullHunter_Unreal.mp4",
    screenshot: null,
    note: "Unreal 5 沒有官方網頁版，請下載 Windows 版或看實機錄影。",
    stats: { modules: null, firstPass: null, exeSize: null, fps: null }
  }
];

// 美術製作卡：放在三款引擎後面
window.NULL_HUNTER_ART = {
  name: "Art",
  version: "4.8",
  title: "美術製作",
  meta: "Flow 美術資產包｜三款引擎共用",
  color: "#B9B2E8",
  preview: "art/preview.html",
  cover: "art/scenes/07_normal_battle.png",
  note: "完整流程預覽可看故事、轉場、Cube 修復、頭目戰與成功／失敗結局；場景圖庫是 11 個畫面的素材對照。",
  stats: [
    { v: "11", k: "場景" },
    { v: "140", k: "特效格" },
    { v: "46", k: "音效" },
    { v: "6", k: "字型" }
  ],
  scenes: [
    ["01_title", "標題"],
    ["02_controls", "操作說明"],
    ["03_prologue_deadline", "序章｜期限"],
    ["04_prologue_build99", "序章｜Build 99"],
    ["05_prologue_errors", "序章｜錯誤湧現"],
    ["06_prologue_cursor01", "序章｜Cursor 01"],
    ["07_normal_battle", "一般戰鬥"],
    ["08_boss_warning", "頭目警告"],
    ["09_boss_battle", "頭目戰"],
    ["10_success", "成功"],
    ["11_failure", "失敗"]
  ].map(([file, label]) => ({ src: "art/scenes/" + file + ".png", label }))
};
