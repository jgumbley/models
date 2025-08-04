# Qwen3-30B-A3B-Instruct-2507 optimization for Ryzen 7 9700X + RX 7900 XTX
# Non-thinking instruct model with improved instruction following and 256K context
CTX = 32768       # 32K context - native support, scales to 256K
TEMP = 0.7        # Recommended temperature for instruct model
BATCH = 2048      # Large batch for throughput
THREADS = 14      # Use most CPU threads
NGL = 99          # Auto-detect max layers for full GPU utilization
TOPK = 20         # Recommended sampling from docs
TOPP = 0.8        # Recommended for better instruction following
MINP = 0.0        # Minimum P sampling

# Optimization flags (can be overridden if needed)
FLASH_ATTN = --flash-attn
SPLIT_MODE = --split-mode layer
BENCH_PROMPT = "Write a Python function that implements binary search on a sorted array:"