#!/usr/bin/env bash
# formula.sh NAME VERSION SHA256SUMS prints Formula/NAME.rb for that release of takodotid/NAME, with each archive's
# SHA-256 from SHA256SUMS. NAME is tack or strait. Circuit's release writes its own formula.
set -euo pipefail

name=$1 version=$2 sums=$3
[[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "$version is not a stable version" >&2; exit 1; }

case $name in
tack)
	class=Tack
	desc="Switch a stateful workload's primary between sites, in step with GitOps"
	archive() { echo "tack-v$version-$1-$2.tar.gz"; }
	install='    bin.install "tack"
    man1.install Dir["man/man1/*.1"]
    pkgshare.install "failover.tako.id_sitefailovers.yaml"
    generate_completions_from_executable(bin/"tack", "completion")'
	;;
strait)
	class=Strait
	desc="Virtual service between Kubernetes clusters at different sites"
	archive() { echo "strait_v${version}_$1_$2.tar.gz"; }
	install='    bin.install "strait"
    # kubectl-strait is the same binary, run by kubectl as "kubectl strait". kubectl completes it with
    # kubectl_complete-strait on the PATH.
    bin.install_symlink "strait" => "kubectl-strait"
    bin.install_symlink "strait" => "kubectl_complete-strait"
    man1.install Dir["man/man1/*.1"]
    generate_completions_from_executable(bin/"strait", "completion")'
	;;
*)
	echo "no formula for $name" >&2
	exit 1
	;;
esac

# The url and sha256 lines of one archive.
asset() {
	local file sum
	file=$(archive "$1" "$2")
	sum=$(awk -v f="$file" '$2 == f { print $1 }' "$sums")
	[[ $sum =~ ^[0-9a-f]{64}$ ]] || { echo "SHA256SUMS has no $file" >&2; exit 1; }
	printf '      url "https://github.com/takodotid/%s/releases/download/v%s/%s"\n      sha256 "%s"\n' "$name" "$version" "$file" "$sum"
}

# Each is set here, not in the heredoc, so that a missing archive stops the script.
macos_arm=$(asset darwin arm64)
macos_intel=$(asset darwin amd64)
linux_arm=$(asset linux arm64)
linux_intel=$(asset linux amd64)

cat <<RUBY
class $class < Formula
  desc "$desc"
  homepage "https://$name.tako.id"
  license "Apache-2.0"

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
    assert_match "v#{version}", shell_output("#{bin}/$name --version")
  end
end
RUBY
