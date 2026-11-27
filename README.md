# Tako's Homebrew tap

Tako's command-line tools for Homebrew, on macOS and Linux.

| Formula | Install |
|---|---|
| [Circuit](https://circuit.tako.id) | `brew install takodotid/tap/circuit` |
| [Tack](https://tack.tako.id) | `brew install takodotid/tap/tack` |
| [Strait](https://strait.tako.id) | `brew install takodotid/tap/strait` |

Update one with `brew upgrade takodotid/tap/<formula>`. Circuit installed this way does not update itself.

The workflow `update` checks each hour for a new stable release of each project. It verifies the release's `SHA256SUMS` (Tack and Strait: GitHub's attestation of their release workflow; Circuit: its release key), and pushes the formula once it installs and passes `brew test` and `brew audit`.

GitHub turns off a public repository's scheduled workflows after 60 days without activity. Run `update` by hand, or turn it on again under Actions, after a quiet stretch.
