nasm -fobj main_ex26.asm

nasm -fobj second_ex26.asm

alink -oPE -subsys console -entry start main_ex26.obj second_ex26.obj