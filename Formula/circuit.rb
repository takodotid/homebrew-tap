class Circuit < Formula
  desc "Declarative, vendor-neutral network configuration"
  homepage "https://circuit.tako.id"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/takodotid/circuit/releases/download/v1.4.0/circuit-darwin-arm64"
      sha256 "21cffe97952767183b0a5659e77b5fe767bc0ebd69fec3b61952a74ef720fe02"
    end
    on_intel do
      url "https://github.com/takodotid/circuit/releases/download/v1.4.0/circuit-darwin-x64"
      sha256 "fbe80431d18b43ba02494f89faea91baf3098ed326fadaf853d6a673f3cef239"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takodotid/circuit/releases/download/v1.4.0/circuit-linux-arm64"
      sha256 "c22201871747a8799ef8a4c224938a469a2072d6998c234658d7df922176d4f8"
    end
    on_intel do
      url "https://github.com/takodotid/circuit/releases/download/v1.4.0/circuit-linux-x64"
      sha256 "6341d3702c15365661eaa35b22b4eaf73139b0f3f084110985691895f1544b02"
    end
  end

  def install
    bin.install Dir["circuit-*"].first => "circuit"
    # With this file beside it, Circuit leaves its updates and its removal to Homebrew.
    (pkgshare/"package-manager").write <<~EOS
      brew upgrade takodotid/tap/circuit
      brew uninstall takodotid/tap/circuit
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/circuit --version").strip
  end
end
