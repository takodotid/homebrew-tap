#!/usr/bin/env bash
# formula.sh NAME VERSION SHA256SUMS prints Formula/NAME.rb for that release of takodotid/NAME, with each download's
# SHA-256 from SHA256SUMS. NAME is circuit, tack or strait.
set -euo pipefail

name=$1 version=$2 sums=$3
[[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "$version is not a stable version" >&2; exit 1; }

case $name in
circuit)
	class=Circuit
	desc="Declarative, vendor-neutral network configuration"
	license=BUSL-1.1
	download() { echo "circuit-$1-${2/amd64/x64}"; }
	install='    bin.install Dir["circuit-*"].first => "circuit"
    # With this file beside it, Circuit leaves its updates and its removal to Homebrew.
    (pkgshare/"package-manager").write <<~EOS
      brew upgrade takodotid/tap/circuit
      brew uninstall takodotid/tap/circuit
    EOS'
	test='    assert_equal version.to_s, shell_output("#{bin}/circuit --version").strip'
	;;
tack)
	class=Tack
	desc="Switch a stateful workload's primary between sites, in step with GitOps"
	license=Apache-2.0
	download() { echo "tack-v$version-$1-$2.tar.gz"; }
	install='    bin.install "tack"
    man1.install Dir["man/man1/*.1"]
    pkgshare.install "failover.tako.id_sitefailovers.yaml"
    generate_completions_from_executable(bin/"tack", "completion")'
	test='    assert_match "v#{version}", shell_output("#{bin}/tack --version")'
	;;
strait)
	class=Strait
	desc="Virtual service between Kubernetes clusters at different sites"
	license=Apache-2.0
	download() { echo "strait_v${version}_$1_$2.tar.gz"; }
	install='    bin.install "strait"
    # kubectl-strait is the same binary, run by kubectl as "kubectl strait". kubectl completes it with
    # kubectl_complete-strait on the PATH.
    bin.install_symlink "strait" => "kubectl-strait"
    bin.install_symlink "strait" => "kubectl_complete-strait"
    man1.install Dir["man/man1/*.1"]
    generate_completions_from_executable(bin/"strait", "completion")'
	test='    assert_match "v#{version}", shell_output("#{bin}/strait --version")'
	;;
*)
	echo "no formula for $name" >&2
	exit 1
	;;
esac

# The url and sha256 lines of one download.
asset() {
	local file sum
	file=$(download "$1" "$2")
	sum=$(awk -v f="$file" '$2 == f { print $1 }' "$sums")
	[[ $sum =~ ^[0-9a-f]{64}$ ]] || { echo "SHA256SUMS has no $file" >&2; exit 1; }
	printf '      url "https://github.com/takodotid/%s/releases/download/v%s/%s"\n      sha256 "%s"\n' "$name" "$version" "$file" "$sum"
}

# Each is set here, not in the heredoc, so that a missing download stops the script.
macos_arm=$(asset darwin arm64)
macos_intel=$(asset darwin amd64)
linux_arm=$(asset linux arm64)
linux_intel=$(asset linux amd64)

cat <<RUBY
class $class < Formula
  desc "$desc"
  homepage "https://$name.tako.id"
  license "$license"

  on_macos do
    on_arm do
$macos_arm
    end
    on_intel do
$macos_intel
    end
  end

  on_linux do
    on_arm do
$linux_arm
    end
    on_intel do
$linux_intel
    end
  end

  def install
$install
  end

  test do
$test
  end
end
RUBY
