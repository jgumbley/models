LLAMA_CLI    ?= /opt/llama.cpp/llama-cli
LLAMA_SERVER ?= /opt/llama.cpp/llama-server

# Tuned for Ryzen 7 9700X (16 threads) + 60GB RAM
THREADS ?= 14        # leave 2 threads for system
CTX     ?= 32768     # large context with your RAM
BATCH   ?= 1024      # bigger batches for throughput
TEMP    ?= 0.7
TOPK    ?= 40
TOPP    ?= 0.95
SEED    ?= -1
PORT    ?= 8080
NGL     ?= 40        # GPU layers for RX 7900 XTX (24GB VRAM)