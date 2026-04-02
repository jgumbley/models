LLAMA_CLI    ?= llama-cli
LLAMA_SERVER ?= llama-server

# Tuned for Ryzen 7 9700X (16 threads) + 60GB RAM
THREADS ?= 14        # leave 2 threads for system
CTX     ?= 32768     # large context with your RAM
BATCH   ?= 1024      # bigger batches for throughput
TEMP    ?= 0.7
TOPK    ?= 20
TOPP    ?= 0.8
MINP    ?= 0.0
SEED    ?= -1
PORT    ?= 8000
NGL     ?= 40        # GPU layers for RX 7900 XTX (24GB VRAM)

# Optimization flags
FLASH_ATTN   ?= --flash-attn on
SPLIT_MODE   ?= --split-mode layer
BENCH_PROMPT ?= "def merge_sort(arr):"
