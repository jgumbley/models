# Mission

Make this `models` repo self-contained for local inference setup.

## Current objective

- Remove any dependency on `../setup-system`.
- Keep Gemma 4 26B support in place.
- Use the local Ansible content in this repo to configure inference.
- Get the local inference setup working on ROCm 6 first.
- Upgrade ROCm step by step only after the ROCm 6 path is working.

## Current playbook scope

- `make setup` uses the repo-local playbook.
- `make check-ansible` validates the local Ansible entrypoint before a full setup run.
- Invocation logic stays local to this repo.
- Unrelated Asterisk installation and service management are removed from the inference playbook.
- Non-essential GPU and CPU performance forcing are removed; only the GPU access group assignment needed for local inference remains.
