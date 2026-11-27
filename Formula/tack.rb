class Tack < Formula
  desc "Switch a stateful workload's primary between sites, in step with GitOps"
  homepage "https://tack.tako.id"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/takodotid/tack/releases/download/v1.7.0/tack-v1.7.0-darwin-arm64.tar.gz"
      sha256 "ff15744d7466093b5a3b4bcee2c61260cc5fb8cab0bed6a0c6f2e31a1f2b7bbe"
    end
    on_intel do
      url "https://github.com/takodotid/tack/releases/download/v1.7.0/tack-v1.7.0-darwin-amd64.tar.gz"
      sha256 "f44059056a26c6d708d5e9498fe09428689347ab60c9a5ac0e4e1b9c49b4dd42"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takodotid/tack/releases/download/v1.7.0/tack-v1.7.0-linux-arm64.tar.gz"
      sha256 "8c4d0346c32ac614ab80c29a09e5ea7291d45b90b56978ea60a5b250a66ac288"
    end
    on_intel do
      url "https://github.com/takodotid/tack/releases/download/v1.7.0/tack-v1.7.0-linux-amd64.tar.gz"
      sha256 "810ef9778877b38b4cccbc71c67a812bf8a8f98fa5a0a4bfe71b385c28220a82"
    end
  end

  def install
    bin.install "tack"
    man1.install Dir["man/man1/*.1"]
    pkgshare.install "failover.tako.id_sitefailovers.yaml"
    generate_completions_from_executable(bin/"tack", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/tack --version")
  end
end
