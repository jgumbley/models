# DeepSeek-R1-32B specific tuning
CTX = 16384      # Balanced context size for 24GB VRAM
TEMP = 0.4       # Lower temp for more coherent reasoning
BATCH = 1024     # Larger batch size for better GPU throughput
THREADS = 8      # Reduce CPU threads to focus on GPU processing
NGL = 99         # Offload all possible layers to GPU (auto-detects max)
