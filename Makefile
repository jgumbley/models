# models/Makefile
include common.mk

MODEL ?= deepseek-r1-32b
MODEL_FILE ?= $(MODEL)/model.gguf

# Per-model overrides if present
-include $(MODEL)/params.mk

.PHONY: chat serve bench list clean

chat: $(MODEL_FILE)
	HIP_VISIBLE_DEVICES=0 llama-cli \
	  -m $(MODEL_FILE) \
	  -i \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --temp $(TEMP) --top-k $(TOPK) --top-p $(TOPP) --seed $(SEED)

serve: $(MODEL_FILE)
	HIP_VISIBLE_DEVICES=0 llama-server \
	  -m $(MODEL_FILE) \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --host 0.0.0.0 --port $(PORT)

bench: $(MODEL_FILE)
	HIP_VISIBLE_DEVICES=0 llama-cli \
	  -m $(MODEL_FILE) \
	  -t $(THREADS) -c $(CTX) -b $(BATCH) -ngl $(NGL) \
	  --n-predict 512 --temp 0 --repeat_penalty 1.0 \
	  -p "Write a detailed explanation of machine learning in 512 tokens." \
	  --no-conversation --verbose

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