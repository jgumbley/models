# models/Makefile
include common.mk

MODEL ?= qwen3-32b
MODEL_FILE ?= $(MODEL)/model.gguf

# Per-model overrides if present
-include $(MODEL)/params.mk

.PHONY: chat serve bench list clean

chat: $(MODEL_FILE)
	HIP_VISIBLE_DEVICES=0 $(LLAMA_CLI) \
	  -m $(MODEL_FILE) \
	  -i \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --temp $(TEMP) --top-k $(TOPK) --top-p $(TOPP) --seed $(SEED) \
	  $(FLASH_ATTN) $(SPLIT_MODE)

serve: $(MODEL_FILE)
	HIP_VISIBLE_DEVICES=0 $(LLAMA_SERVER) \
	  -m $(MODEL_FILE) \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --host 0.0.0.0 --port $(PORT) \
	  $(FLASH_ATTN) $(SPLIT_MODE)

bench: $(MODEL_FILE)
	@echo "=== Benchmarking tokens/sec for $(MODEL) ==="
	HIP_VISIBLE_DEVICES=0 $(LLAMA_CLI) \
	  -m $(MODEL_FILE) \
	  -p $(BENCH_PROMPT) -n 512 -t $(THREADS) --temp $(TEMP) -s 1 --ctx-size $(CTX) \
	  -ngl $(NGL) --top-k $(TOPK) --top-p $(TOPP) \
	  $(FLASH_ATTN) $(SPLIT_MODE) --no-conversation

list:
	@find . -maxdepth 1 -mindepth 1 -type d ! -name ".git" \
	 | sed 's|^\./||' | sort

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