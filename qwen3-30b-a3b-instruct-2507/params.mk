# Qwen3-30B-A3B-Instruct-2507 optimization for Ryzen 7 9700X + RX 7900 XTX
# Non-thinking model with improved instruction following
CTX = 32768       # 32K context - native support, scales to 256K
TEMP = 0.7        # Standard temperature for instruct model
BATCH = 2048      # Large batch for throughput
THREADS = 14      # Use most CPU threads
NGL = 99          # Auto-detect max layers for full GPU utilization
TOPK = 40         # Standard sampling
TOPP = 0.9        # Higher for better instruction following

# Optimization flags (can be overridden if needed)
FLASH_ATTN = --flash-attn
SPLIT_MODE = --split-mode layer
BENCH_PROMPT = "Write a Python function to calculate the factorial of a number:"