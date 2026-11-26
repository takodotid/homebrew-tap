# Tako's Homebrew tap

Tako's command-line tools for Homebrew, on macOS and Linux.

| Formula | Install |
|---|---|
| [Circuit](https://circuit.tako.id) | `brew install takodotid/tap/circuit` |
| [Tack](https://tack.tako.id) | `brew install takodotid/tap/tack` |
| [Strait](https://strait.tako.id) | `brew install takodotid/tap/strait` |

Update one with `brew upgrade takodotid/tap/<formula>`. Circuit installed this way does not update itself.

Circuit's release writes its formula here. For Tack and Strait, the workflow `update` checks each hour for a new stable release, verifies its attested `SHA256SUMS`, and pushes the formula once it installs and passes `brew test` and `brew audit`.
