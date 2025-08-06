import curses
import re
import time
import math
import sys
import os

MODELS = [
    "deepseek-r1-32b",
    "deepseek-r1-qwen7b", 
    "gpt-oss-20b",
    "mythomax-l2-13b",
    "qwen2.5-7b-instruct",
    "qwen2.5-coder-14b-instruct",
    "qwen2.5-coder-32b-instruct",
    "qwen3-30b-a3b",
    "qwen3-30b-a3b-instruct-2507",
    "qwen3-32b",
    "qwen3-coder-30b-a3b-instruct",
]

def get_current_model():
    try:
        with open('selected.mk', 'r') as f:
            content = f.read()
            match = re.search(r'SELECTED_MODEL = (.+)', content)
            if match:
                return match.group(1).strip()
    except FileNotFoundError:
        pass
    return "qwen3-30b-a3b-instruct-2507"

def save_model(model):
    with open('selected.mk', 'w') as f:
        f.write(f"SELECTED_MODEL = {model}\n")

def draw_wave(stdscr, y, x, width, phase, amplitude=1):
    for i in range(width):
        wave_y = int(amplitude * math.sin((i + phase) * 0.3))
        try:
            stdscr.addstr(y + wave_y, x + i, "~", curses.color_pair(1))
        except:
            pass

def draw_liquid_border(stdscr, height, width, phase):
    for i in range(width):
        wave1 = int(2 * math.sin((i + phase) * 0.2))
        wave2 = int(2 * math.sin((i + phase * 1.3) * 0.15))
        try:
            stdscr.addstr(2 + wave1, i, "░", curses.color_pair(2))
            stdscr.addstr(height - 3 + wave2, i, "░", curses.color_pair(2))
        except:
            pass

def liquid_selector(stdscr):
    curses.curs_set(0)
    curses.start_color()
    curses.use_default_colors()
    
    try:
        curses.init_pair(1, curses.COLOR_CYAN, -1)
        curses.init_pair(2, curses.COLOR_BLUE, -1)
        curses.init_pair(3, curses.COLOR_MAGENTA, -1)
        curses.init_pair(4, curses.COLOR_GREEN, -1)
        curses.init_pair(5, curses.COLOR_YELLOW, -1)
    except:
        pass
    
    stdscr.timeout(100)
    
    current_model = get_current_model()
    try:
        selected_idx = MODELS.index(current_model)
    except ValueError:
        selected_idx = 0
    
    phase = 0
    smooth_idx = float(selected_idx)
    target_idx = selected_idx
    
    while True:
        stdscr.clear()
        height, width = stdscr.getmaxyx()
        phase += 0.5
        
        smooth_idx += (target_idx - smooth_idx) * 0.15
        
        draw_liquid_border(stdscr, height, width, phase)
        
        title = "◉ LIQUID MODEL SELECTOR ◉"
        try:
            stdscr.addstr(1, (width - len(title)) // 2, title, curses.color_pair(3) | curses.A_BOLD)
        except:
            pass
        
        current_text = f"∿ Current: {current_model} ∿"
        try:
            stdscr.addstr(4, (width - len(current_text)) // 2, current_text, curses.color_pair(1))
        except:
            pass
        
        start_y = 7
        center_x = width // 2
        
        for i, model in enumerate(MODELS):
            y = start_y + i
            if y >= height - 4:
                break
            
            distance = abs(i - smooth_idx)
            if distance < 0.1:
                distance = 0.1
            
            scale = max(0.3, 1.0 / (1.0 + distance * 0.8))
            wave_offset = int(3 * math.sin(phase * 0.7 + i * 0.5) * scale)
            
            display_text = model
            if i == target_idx:
                display_text = f"❯ {model} ❮"
                color_pair = curses.color_pair(4)
                attr = curses.A_BOLD | curses.A_REVERSE
                
                for j in range(len(display_text)):
                    wave_x = int(2 * math.sin(phase * 0.5 + j * 0.3))
                    try:
                        stdscr.addstr(y, center_x - len(display_text)//2 + j + wave_x + wave_offset, 
                                    display_text[j], color_pair | attr)
                    except:
                        pass
            else:
                opacity = max(0.2, scale)
                if opacity > 0.7:
                    color_pair = curses.color_pair(5)
                    attr = curses.A_NORMAL
                else:
                    color_pair = curses.color_pair(2)
                    attr = curses.A_DIM
                
                try:
                    stdscr.addstr(y, center_x - len(display_text)//2 + wave_offset, 
                                display_text, color_pair | attr)
                except:
                    pass
        
        instructions = "∿ ↑↓ Flow | Enter Select | q Quit ∿"
        try:
            stdscr.addstr(height - 2, (width - len(instructions)) // 2, 
                        instructions, curses.color_pair(1))
        except:
            pass
        
        try:
            stdscr.refresh()
        except:
            pass
        
        key = stdscr.getch()
        
        if key == ord('q') or key == 27:
            break
        elif key == curses.KEY_UP:
            target_idx = (target_idx - 1) % len(MODELS)
        elif key == curses.KEY_DOWN:
            target_idx = (target_idx + 1) % len(MODELS)
        elif key == curses.KEY_ENTER or key in [10, 13]:
            save_model(MODELS[target_idx])
            
            stdscr.clear()
            success_msg = f"◉ SELECTED: {MODELS[target_idx]} ◉"
            try:
                stdscr.addstr(height // 2, (width - len(success_msg)) // 2, 
                            success_msg, curses.color_pair(4) | curses.A_BOLD)
                stdscr.addstr(height // 2 + 2, (width - 30) // 2, 
                            "∿ Flowing to new model... ∿", curses.color_pair(1))
            except:
                pass
            
            for i in range(20):
                try:
                    wave_text = "~" * (i + 10)
                    stdscr.addstr(height // 2 + 4, (width - len(wave_text)) // 2, 
                                wave_text, curses.color_pair(2))
                    stdscr.refresh()
                    time.sleep(0.1)
                except:
                    pass
            break

def fallback_selector():
    current_model = get_current_model()
    
    print("\n" + "◉" * 60)
    print(" " * 20 + "LIQUID MODEL SELECTOR")
    print("◉" * 60)
    print(f"∿ Current: {current_model} ∿")
    print("~" * 60)
    
    for i, model in enumerate(MODELS, 1):
        marker = " ❯ " if model == current_model else "   "
        print(f"{marker}{i:2d}. {model}")
    
    print("~" * 60)
    
    while True:
        try:
            choice = input("∿ Enter model number (1-{}) or 'q' to quit: ".format(len(MODELS)))
            
            if choice.lower() == 'q':
                print("∿ No changes made ∿")
                return
            
            idx = int(choice) - 1
            if 0 <= idx < len(MODELS):
                selected_model = MODELS[idx]
                save_model(selected_model)
                print(f"\n◉ SELECTED: {selected_model} ◉")
                print("∿ Model selection updated ∿")
                return
            else:
                print(f"Please enter a number between 1 and {len(MODELS)}")
                
        except ValueError:
            print("Please enter a valid number or 'q'")
        except KeyboardInterrupt:
            print("\n∿ No changes made ∿")
            return

def main():
    if os.getenv('TERM') and sys.stdout.isatty():
        try:
            curses.wrapper(liquid_selector)
        except Exception as e:
            print(f"Curses failed: {e}")
            fallback_selector()
    else:
        fallback_selector()

if __name__ == "__main__":
    main()