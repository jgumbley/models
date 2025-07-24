# models/Makefile
include common.mk

MODEL ?= deepseek-r1-qwen7b
MODEL_FILE ?= $(MODEL)/model.gguf
PROMPT ?= prompts/eval.txt

# Per-model overrides if present
-include $(MODEL)/params.mk

.PHONY: chat serve bench list clean

chat: $(MODEL_FILE)
	llama-cli \
	  -m $(MODEL_FILE) \
	  -p "$$(cat $(PROMPT))" \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --temp $(TEMP) --top-k $(TOPK) --top-p $(TOPP) --seed $(SEED)

serve: $(MODEL_FILE)
	llama-server \
	  -m $(MODEL_FILE) \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --port $(PORT)

bench: $(MODEL_FILE)
	llama-cli \
	  -m $(MODEL_FILE) \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --prompt "Benchmarking..." \
	  --n-predict 512 --temp 0 --repeat_penalty 1

list:
	@find . -maxdepth 1 -mindepth 1 -type d ! -name "prompts" ! -name ".git" \
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