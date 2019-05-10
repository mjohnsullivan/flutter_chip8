# Attribution

ibm_logo.ch8: https://github.com/Dillonb/chip8/blob/master/programs/IBM%20Logo.ch8

framed_mk1_samways_1980.ch8
https://github.com/Dillonb/chip8/blob/master/programs/Framed%20MK1%20%5BGV%20Samways%2C%201980%5D.ch8

framed_mk2_samways_1980.ch8
https://github.com/Dillonb/chip8/blob/master/programs/Framed%20MK2%20%5BGV%20Samways%2C%201980%5D.ch8

clock_bill_fisher_1981.ch8
https://github.com/Dillonb/chip8/blob/master/programs/Clock%20Program%20%5BBill%20Fisher%2C%201981%5D.ch8

life_samways_1980.ch8
https://github.com/Dillonb/chip8/blob/master/programs/Life%20%5BGV%20Samways%2C%201980%5D.ch8

keypad_test_hap_2006.ch8
https://github.com/Dillonb/chip8/blob/master/programs/Keypad%20Test%20%5BHap%2C%202006%5D.ch8

space_invaders_david_winter.ch8
https://github.com/dmatlack/chip8/tree/master/roms/games

/***********************************/
         BC_Chip8Test
/***********************************/
DESCRIPTION: Test the conditional jumps, the mathematical and logical operations of Chip 8
AUTHOR: BestCoder
CONTACT: mail: bestcoder@ymail.com
COPYRIGHT: You can use this rom and redistribute at will until the credits are awarded me. No commercial use is allowed without my permission!
VERSION: EN 07/01/2011
/***********************************/
    HOW TO USE IT:
/***********************************/
Each error is accompanied by a number that identifies the opcode in question. If all tests are positive, the rom will display on screen  "BON" meaning "GOOD".
/***********************************/
    CORRESPONDENCE
/***********************************/
E 01: 3XNN verify that the jump condition is fair
E 02: 5XY0 verify that the jump condition is fair
E 03: 4XNN verify that the jump condition is fair
E 04: 7XNN check the result of the addition
E 05: 8XY5 verify that VF is set to 0 when there is a borrow
E 06: 8XY5 verify that VF is set to 1 when there is no borrow
E 07: 8XY7 verify that VF is set to 0 when there is a borrow
E 08: 8XY7 verify that VF is set to 1 when there is no borrow
E 09: 8XY1 check the result of the OR operation
E 10: 8XY2 check the result of AND operation
E 11: 8XY3 check the result of the XOR operation
E 12: 8XYE verify that VF is set to the MSB (most significant bit or most left) before the shift and  VF does not take value 0 every time
E 13: 8XYE verify that VF is set to the MSB (most significant bit or most left) before the shift and  VF does not take value 1 every time 
E 14: 8XY6 verify that VF is set to the LSB (least significant bit or most right ) before the shift and  VF does not take value 0 every time
E 15: 8XY6 verify that VF is the LSB (least significant bit or most right) before the shift and  VF does not take value 1 every time 
E 16: FX55 and FX65 verify that these two opcodes are implemented. The error may come from one or the other or both are defects.
E 17: FX33 calculating the binary representation is mistaken or the result is poorly stored into memory or poorly poped (FX65 or FX1E).
/**************************/
    Happy debugging