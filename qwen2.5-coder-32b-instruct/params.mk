# Qwen2.5-Coder-32B-Instruct aggressive optimization for Ryzen 7 9700X + RX 7900 XTX
CTX = 16384       # Larger context possible with Q4_K_M
TEMP = 0.2        # Lower temp for precise coding 
BATCH = 2048      # Larger batch for better throughput
THREADS = 14      # Use most CPU threads
NGL = 99          # Auto-detect max layers (should be ~64)
TOPK = 20         # Focused sampling for code generation
TOPP = 0.9        # Slightly lower for deterministic code