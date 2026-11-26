class Strait < Formula
  desc "Virtual service between Kubernetes clusters at different sites"
  homepage "https://strait.tako.id"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/takodotid/strait/releases/download/v1.6.0/strait_v1.6.0_darwin_arm64.tar.gz"
      sha256 "b6cefc18cd246f2a888644664cf5e440425a30a978dc80893d7c9923a4880f97"
    end
    on_intel do
      url "https://github.com/takodotid/strait/releases/download/v1.6.0/strait_v1.6.0_darwin_amd64.tar.gz"
      sha256 "7c5beca6f6e366c074c4379edc478e37f020c1deb798a8fb6d270fd127244a87"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/takodotid/strait/releases/download/v1.6.0/strait_v1.6.0_linux_arm64.tar.gz"
      sha256 "b31b94eeb1aced90b4a2232cd6f8e1708a7db4c79e989ff5c3bc0daeb17e7d00"
    end
    on_intel do
      url "https://github.com/takodotid/strait/releases/download/v1.6.0/strait_v1.6.0_linux_amd64.tar.gz"
      sha256 "b31e8f170947272808c11f29cd9c138b2d431659b9aa3bf75d34f2f363454981"
    end
  end

  def install
    bin.install "strait"
    # kubectl-strait is the same binary, run by kubectl as "kubectl strait". kubectl completes it with
    # kubectl_complete-strait on the PATH.
    bin.install_symlink "strait" => "kubectl-strait"
    bin.install_symlink "strait" => "kubectl_complete-strait"
    man1.install Dir["man/man1/*.1"]
    generate_completions_from_executable(bin/"strait", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/strait --version")
  end
end
