cask "editor-jumper-for-xcode" do
  version "1.2.6"
  sha256 "ba69e9c42fd55915e0f9b57294d479347ea84260355d771a05015ee33347679d"

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