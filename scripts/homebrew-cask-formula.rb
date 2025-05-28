cask "editor-jumper-for-xcode" do
  version "1.2.4"
  sha256 "5494d2ce2c7e6954b28db2640bf807d3120fdeaa530f0ee5c97ef8bd0c14f609"

  url "https://github.com/xiangaoole/EditorJumper-X/releases/download/v#{version}/EditorJumper-X-#{version}.dmg"
  name "EditorJumper for Xcode"
  desc "Seamlessly jump from Xcode to Cursor editor"
  homepage "https://github.com/xiangaoole/EditorJumper-X"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "EditorJumper for Xcode.app"

  zap trash: [
    "~/Library/Application Support/EditorJumper-X",
    "~/Library/Caches/EditorJumper-X",
    "~/Library/Preferences/com.haroldgao.EditorJumper-X.plist",
  ]
end 