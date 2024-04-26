nasm -fobj calculeaza.asm

nasm -fobj pb5.asm

alink -oPE -subsys console -entry start pb5.obj calculeaza.obj