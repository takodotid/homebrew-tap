class Circuit < Formula
  desc "Declarative, vendor-neutral network configuration"
  homepage "https://circuit.tako.id"
  version "1.2.1"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/takodotid/circuit/releases/download/v1.2.1/circuit-darwin-arm64"
      sha256 "d56dba773dae8581c0b0e34578d3a3c352fa19cf218dbdb6bad13b07a66d06b0"
    end
    on_intel do
      url "https://github.com/takodotid/circuit/releases/download/v1.2.1/circuit-darwin-x64"
      sha256 "9f55692097794b13cfe2d8c070a1c08d560758f413e9449221eaac142548f593"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takodotid/circuit/releases/download/v1.2.1/circuit-linux-arm64"
      sha256 "92a92ce3e2e9a7d53ae3e98005acf1f4479f247588fe2cb5493b475cf2a70995"
    end
    on_intel do
      url "https://github.com/takodotid/circuit/releases/download/v1.2.1/circuit-linux-x64"
      sha256 "696bfd008da82ff0361f02832a75dbf3a930583c1069ab241bb975e849fbe07e"
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
