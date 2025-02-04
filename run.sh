nasm -f win64 -o program.obj program.asm

gcc program.obj -o program.exe

./program.exe