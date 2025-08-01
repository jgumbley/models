# Qwen3-Coder-30B-A3B-Instruct optimization for Ryzen 7 9700X + RX 7900 XTX
# Latest coding-focused model with improved agentic capabilities
CTX = 65536       # Push to 64K context
TEMP = 0.2        # Lower temperature for precise code generation
BATCH = 4096      # Max batch size for throughput
THREADS = 14      # Use most CPU threads
NGL = 99          # All layers on GPU for 30B model - maximize GPU usage
TOPK = 20         # Focused sampling for deterministic code
TOPP = 0.9        # High precision for coding tasks

# Optimization flags
FLASH_ATTN = --flash-attn
SPLIT_MODE = --split-mode layer
BENCH_PROMPT = "def fibonacci(n):"