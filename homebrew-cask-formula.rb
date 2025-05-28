cask "editor-jumper-for-xcode" do
  version "1.2.2"
  sha256 "f37fb8e63cd9e4e2d33554f6a4abb2cbfc35c6bc2de6bf1ba8d066af50d62f10"

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