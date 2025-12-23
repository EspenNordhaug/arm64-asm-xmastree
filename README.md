# arm64-asm-xmastree
Small and simplistic ascii xmas tree written in as raw assembly as possible on Apple Silicon, for educational purposes.
It draws a small ascii christmas tree and lets the star on the top twinkle.
Shows basic setup and and example on how a 2HZ timer can be implemented without realying on c librararies. It's drawback is of course inneficency.
When I get my hand on a Linux ARM64 I will also create a line by line replica.
To compile : clang -arch arm64 -nostdlib -Wl,-e,_start, -Wl,-lSystem -o xmas xmas.s
To run: clear;./xmas
