class Circuit < Formula
  desc "Declarative, vendor-neutral network configuration"
  homepage "https://circuit.tako.id"
  license "BUSL-1.1"

  on_macos do
    on_arm do
      url "https://github.com/takodotid/circuit/releases/download/v1.3.0/circuit-darwin-arm64"
      sha256 "205205fea97db3b970bef741d9d507b19568bc6222f6d8550d16ac0a09bcd1f4"
    end
    on_intel do
      url "https://github.com/takodotid/circuit/releases/download/v1.3.0/circuit-darwin-x64"
      sha256 "038b2badeb5d4bed262b0ca940834f360b4579e924b85bb6ea6ed4348f753c27"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takodotid/circuit/releases/download/v1.3.0/circuit-linux-arm64"
      sha256 "76687097c863049b83ecc512ca04092f536fa4a05d075ed290d6a0cd4ca9f3e3"
    end
    on_intel do
      url "https://github.com/takodotid/circuit/releases/download/v1.3.0/circuit-linux-x64"
      sha256 "efd6924f8fb1c09e6a4b7d5cb6c0027a081af80e1a2c7373b18c637d7faecb0d"
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
