# Qwen3-32B-Instruct optimization for Ryzen 7 9700X + RX 7900 XTX
CTX = 20480       # 20K context - should fit in remaining VRAM
TEMP = 0.2        # Lower temp for precise coding 
BATCH = 2048      # Large batch for throughput
THREADS = 14      # Use most CPU threads
NGL = 99          # Auto-detect max layers for full GPU utilization
TOPK = 20         # Focused sampling for code generation
TOPP = 0.9        # Slightly lower for deterministic code

# Optimization flags (can be overridden if needed)
FLASH_ATTN = --flash-attn
SPLIT_MODE = --split-mode layer
BENCH_PROMPT = "def merge_sort(arr):"