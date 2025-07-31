# Qwen3-30B-A3B optimization for Ryzen 7 9700X + RX 7900 XTX
CTX = 32768       # 32K context - native support
TEMP = 0.7        # Non-thinking mode default
BATCH = 2048      # Large batch for throughput
THREADS = 14      # Use most CPU threads
NGL = 99          # Auto-detect max layers for full GPU utilization
TOPK = 40         # Standard sampling for MoE model
TOPP = 0.8        # Non-thinking mode default

# Optimization flags (can be overridden if needed)
FLASH_ATTN = --flash-attn
SPLIT_MODE = --split-mode layer
BENCH_PROMPT = "def fibonacci(n):"