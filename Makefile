# models/Makefile
include common.mk
include selected.mk

MODEL ?= $(SELECTED_MODEL)
MODEL_FILE ?= $(MODEL)/model.gguf

# Per-model overrides if present
-include $(MODEL)/params.mk

.PHONY: chat serve bench list clean mytho mytho-serve model inference claude

chat: $(MODEL_FILE)
	HSA_OVERRIDE_GFX_VERSION=11.0.0 HIP_VISIBLE_DEVICES=0 GPU_DEVICE_ORDINAL=0 $(LLAMA_CLI) \
	  -m $(MODEL_FILE) \
	  -i \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --temp $(TEMP) --top-k $(TOPK) --top-p $(TOPP) --min-p $(MINP) --seed $(SEED) \
	  $(FLASH_ATTN) $(SPLIT_MODE)

serve: $(MODEL_FILE)
	HSA_OVERRIDE_GFX_VERSION=11.0.0 HIP_VISIBLE_DEVICES=0 GPU_DEVICE_ORDINAL=0 $(LLAMA_SERVER) \
	  -m $(MODEL_FILE) \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --host 0.0.0.0 --port $(PORT) \
	  --reverse-prompt "<|im_end|>" --reverse-prompt "</tool_call>" \
	  --repeat-penalty 1.05 --min-p 0.0 \
	  --n-predict 4000 \
	  $(FLASH_ATTN) $(SPLIT_MODE) 2>&1 | tee serve.log

bench: $(MODEL_FILE)
	@echo "=== Benchmarking tokens/sec for $(MODEL) ==="
	HSA_OVERRIDE_GFX_VERSION=11.0.0 HIP_VISIBLE_DEVICES=0 GPU_DEVICE_ORDINAL=0 $(LLAMA_CLI) \
	  -m $(MODEL_FILE) \
	  -p $(BENCH_PROMPT) -n 512 -t $(THREADS) --temp $(TEMP) -s 1 --ctx-size $(CTX) \
	  -ngl $(NGL) --top-k $(TOPK) --top-p $(TOPP) --min-p $(MINP) \
	  $(FLASH_ATTN) $(SPLIT_MODE) --no-conversation

list:
	@find . -maxdepth 1 -mindepth 1 -type d ! -name ".git" \
	 | sed 's|^\./||' | sort

model:
	python3 select_model.py

mytho: mythomax-l2-13b/model.gguf
	$(LLAMA_CLI) \
	  -m mythomax-l2-13b/model.gguf \
	  -i \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl 0 \
	  --temp $(TEMP) --top-k $(TOPK) --top-p $(TOPP) --min-p $(MINP) --seed $(SEED)

mytho-serve: mythomax-l2-13b/model.gguf
	$(LLAMA_SERVER) \
	  -m mythomax-l2-13b/model.gguf \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl 0 \
	  --host 0.0.0.0 --port $(PORT) \
	  --repeat-penalty 1.05 --min-p 0.0 \
	  2>&1 | tee mytho-serve.log

inference:
	ansible-playbook ../setup-system/inference.yml -c local -K

claude:
	sudo -E claude

clean:
	rm -f */model.gguf

# File targets for auto-download
qwen2.5-7b-instruct/model.gguf:
	@mkdir -p qwen2.5-7b-instruct
	wget -O $@ https://huggingface.co/bartowski/Qwen2.5-7B-Instruct-GGUF/resolve/main/Qwen2.5-7B-Instruct-Q4_K_M.gguf

deepseek-r1-qwen7b/model.gguf:
	@mkdir -p deepseek-r1-qwen7b
	wget -O $@ https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF/resolve/main/DeepSeek-R1-Distill-Qwen-7B-Q4_K_M.gguf

mythomax-l2-13b/model.gguf:
	@mkdir -p mythomax-l2-13b
	wget -O $@ https://huggingface.co/TheBloke/MythoMax-L2-13B-GGUF/resolve/main/mythomax-l2-13b.Q4_K_M.gguf

qwen2.5-coder-14b-instruct/model.gguf:
	@mkdir -p qwen2.5-coder-14b-instruct
	wget -O $@ https://huggingface.co/bartowski/Qwen2.5-Coder-14B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-14B-Instruct-Q6_K.gguf

deepseek-r1-32b/model.gguf:
	@mkdir -p deepseek-r1-32b
	wget -O $@ https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF/resolve/main/DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf

qwen2.5-coder-32b-instruct/model.gguf:
	@mkdir -p qwen2.5-coder-32b-instruct
	wget -O $@ https://huggingface.co/bartowski/Qwen2.5-Coder-32B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-32B-Instruct-Q4_K_M.gguf

qwen2.5-coder-32b-instruct-q6k/model.gguf:
	@mkdir -p qwen2.5-coder-32b-instruct-q6k
	wget -O $@ https://huggingface.co/bartowski/Qwen2.5-Coder-32B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-32B-Instruct-Q6_K.gguf

qwen3-32b/model.gguf:
	@mkdir -p qwen3-32b
	wget -O $@ https://huggingface.co/bartowski/Qwen_Qwen3-32B-GGUF/resolve/main/Qwen_Qwen3-32B-Q4_K_M.gguf

qwen3-30b-a3b/model.gguf:
	@mkdir -p qwen3-30b-a3b
	wget -O $@ https://huggingface.co/bartowski/Qwen_Qwen3-30B-A3B-GGUF/resolve/main/Qwen_Qwen3-30B-A3B-Q4_K_M.gguf

qwen3-30b-a3b-instruct-2507/model.gguf:
	@mkdir -p qwen3-30b-a3b-instruct-2507
	wget -O $@ https://huggingface.co/unsloth/Qwen3-30B-A3B-Instruct-2507-GGUF/resolve/main/Qwen3-30B-A3B-Instruct-2507-Q4_K_M.gguf

qwen3-coder-30b-a3b-instruct/model.gguf:
	@mkdir -p qwen3-coder-30b-a3b-instruct
	wget -O $@ https://huggingface.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF/resolve/main/Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf

gpt-oss-20b/model.gguf:
	@mkdir -p gpt-oss-20b
	wget -O $@ https://huggingface.co/bartowski/openai_gpt-oss-20b-GGUF/resolve/main/openai_gpt-oss-20b-bf16.gguf