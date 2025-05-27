cask "editor-jumper-for-xcode" do
  version "1.2.0"
  sha256 "c476c330921062edbd2d820eb4860017b6f0e9b84a6d60fc941ce93eb301d36a"

  url "https://github.com/xiangaoole/EditorJumper-X/releases/download/v#{version}/EditorJumper-X-#{version}.dmg"
  name "EditorJumper for Xcode"
  desc "Seamlessly jump from Xcode to Cursor editor"
  homepage "https://github.com/xiangaoole/EditorJumper-X"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "EditorJumper-X.app"

  zap trash: [
    "~/Library/Application Support/EditorJumper-X",
    "~/Library/Caches/EditorJumper-X",
    "~/Library/Preferences/com.haroldgao.EditorJumper-X.plist",
  ]
end 