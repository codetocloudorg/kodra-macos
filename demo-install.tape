# Kodra macOS Install Demo — VHS Tape
# 1080p high-res recording with macOS-native terminal look

Output kodra-install-demo.mp4
Output kodra-install-demo.gif

Set Shell bash
Set FontFamily "Menlo"
Set FontSize 16
Set Width 1920
Set Height 1080
Set Padding 40
Set LetterSpacing 1.0
Set LineHeight 1.4
Set Theme "Pro"
Set Framerate 30
Set TypingSpeed 50ms
Set PlaybackSpeed 1.0

# Silently launch — the script handles the fake prompt + typing effect
Hide
Type "cd /Users/kevinevans/Dev/kodra-macos && clear && bash demo-install.sh --fast 2>&1"
Enter
Sleep 500ms
Show

# Full demo at --fast is ~55s + 5s hold at end
Sleep 80s
