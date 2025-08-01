# Qwen3-Coder-30B-A3B-Instruct optimization for Ryzen 7 9700X + RX 7900 XTX
# Latest coding-focused model with improved agentic capabilities
CTX = 16384       # 16K context to save VRAM
TEMP = 0.2        # Lower temperature for precise code generation
BATCH = 1024      # Smaller batch to save VRAM
THREADS = 14      # Use most CPU threads
NGL = 55          # ~55 layers for 30B model on 24GB VRAM
TOPK = 20         # Focused sampling for deterministic code
TOPP = 0.9        # High precision for coding tasks

# Optimization flags
FLASH_ATTN = --flash-attn
SPLIT_MODE = --split-mode layer
BENCH_PROMPT = "def fibonacci(n):"