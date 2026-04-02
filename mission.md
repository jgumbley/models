# Mission

Keep this `models` repo self-contained for local Gemma 4 inference.

## Scope

- Gemma 4 only.
- Use the local Ansible content in this repo to configure inference.
- Keep all execution routed through `make`.
- Keep `defaults.mk` for runtime defaults and `common.mk` for shared make targets.

## Current baseline

- The repo no longer depends on `../setup-system`.
- `make setup` uses the repo-local playbook.
- `make check-ansible` validates the local Ansible entrypoint and passes with the ROCm 7 changes.
- The local inference playbook now targets ROCm 7.2.1 via AMD's current apt repository flow.
- Gemma 4 remains the only supported inference target in this repo.
- `make digest` works.
- The inference playbook has been trimmed to inference-related setup only.

## Next step

- Run `make setup` on the local host and verify `make serve` and `make chat` for Gemma 4 26B on ROCm 7.
