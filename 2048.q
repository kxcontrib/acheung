/--- 2048 GAME										$
/ $File:		2048.q								$
/ $Author: 		Alan Cheung [ alanc1988@gmail.com ] $
/ $Date:		2014/04/05							$
/ $Q Version:	kdb+ 3.1							$
/ $Version:		1.0									$
/ $Misc:		use "wasd" for directions			$

//// layout
cls:$[.z.o in `l32`l64`s32`s64`v64;{-1 system "clear";};{}];
gameover:{-2 "\n\t _______________________________\n\t|\t\t\t\t|\t\n\t|\tG A M E   O V E R\t|\n\t|_______________________________|"};	
win:{-2 "\n\t _______________________________\n\t|\t\t\t\t|\t\n\t|\t  Y O U   W I N  \t|\n\t|_______________________________|"};
frame:{-2 "\n\t _______________________________\n\t|\t\t\t\t|\t\n\t|\tscore: ",string[x],"\t\t|\n\t|_______________________________|"};
grid:{-1 "\007";x:raze x;x:?[0=raze x;0N;x];
	-2"\t _______ _______ _______ _______
	\t|\t|\t|\t|\t|
	\t|   ",string[x 0],"\t|   ",string[x 1],"\t|   ",string[x 2],"\t|   ",string[x 3],"\t|
	\t|\t|\t|\t|\t|
	\t|_______|_______|_______|_______|
	\t|\t|\t|\t|\t|
	\t|   ",string[x 4],"\t|   ",string[x 5],"\t|   ",string[x 6],"\t|   ",string[x 7],"\t|
	\t|\t|\t|\t|\t|
	\t|_______|_______|_______|_______|
	\t|\t|\t|\t|\t|
	\t|   ",string[x 8],"\t|   ",string[x 9],"\t|   ",string[x 10],"\t|   ",string[x 11],"\t|
	\t|\t|\t|\t|\t|
	\t|_______|_______|_______|_______|
	\t|\t|\t|\t|\t|
	\t|   ",string[x 12],"\t|   ",string[x 13],"\t|   ",string[x 14],"\t|   ",string[x 15],"\t|
	\t|\t|\t|\t|\t|
	\t|_______|_______|_______|_______|";};

//// functionality
newt:{.[$[type[x]in 0 7h;`A;`score];();:;x]};
cpr:{n,(4-count n:x except 0)#0};
init:{A:16#0;A[rand where 0=A]:rand 2 2 4;newt@/:(4 cut A;0)};
motion:{`vec`score!(after;{sum{$[x~0#x;0;x]}d*key d:abs(key[last dc]except key first dc)_(-/)dc:{count@/:(=:)x}@/:(y;x)except\:0}[x;after:$[(=/)cn:count@/:(distinct x;x)except\:0;cpr x;(4=count distinct x except 0)&4=sum 1+(=':){0-':x}x except 0;cpr x;not("j"$())~"j"$where 1b~/:alt:{$[any(=':)x;"b"$x*not -1 rotate abs 0-':x;x]}(=':)modi:x except 0;cpr modi*raze{b:$[(1=sum x)& 1b in -2#x;0b;1b];{$[0b in x;2*x;x]}@/:not(enlist first[i]#x),(i:b+where b~/:x)_x}alt;cpr x except 0]])};

//// start game
value "\\S ",(string `mm$.z.t),string `ss$.z.t;
init();frame[score];grid[A];

.z.pi:{[x]
	if["quit"~except[x;last x];value"\\x .z.pi"];
	if[not(dir:x[0])in"wasd";:()];
	if[dir in"ws";newt flip A];
	$[dir in"wa";
		[if[A~A_new:(res:motion@/:A)`vec;:()];
			newt@/:(A_new;score+sum res`score)];
		[if[A~A_new:(res:motion'[reverse@/:A])`vec;:()];
			newt@/:(reverse@/:A_new;score+sum res`score)]];
	if[dir in"ws";newt flip A];A::raze A;
	if[not 0N~rand where 0=A;A[rand where 0=A]:rand 2 2 4];
	newt 4 cut A;cls();frame[score];grid A;
	if[2048 in raze A;win()];
	if[0=sum 0b=raze A;
		if[{$[any 0b=raze {0-':x}@/:x;0b;any 0b=raze{0-':x}@/:flip x;0b;1b]}A;
			gameover();init()]]};