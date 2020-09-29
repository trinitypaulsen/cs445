#!/bin/sh
make
echo chars
./c- chars.c- > output ; diff output chars.out
echo cprogram
./c- cprogram.c- > output ; diff output cprogram.out
echo everything04
./c- everything04.c- > output ; diff output everything04.out
echo f20
./c- f20.c- > output ; diff output f20.out
echo htmlTest
./c- htmlTest.c- > output ; diff output htmlTest.out
echo mouStringTestsErrors
./c- mouStringTestsErrors.c- > output ; diff output mouStringTestsErrors.out
echo notf20
./c- notf20.c- > output ; diff output notf20.out
echo quoteTest
./c- quoteTest.c- > output ; diff output quoteTest.out
echo scannerCCode
./c- scannerCCode.c- > output ; diff output scannerCCode.out
echo scannerTest
./c- scannerTest.c- > output ; diff output scannerTest.out
echo stringtest
./c- stringtest.c- > output ; diff output stringtest.out
echo testExample
./c- testExample.c- > output ; diff output testExample.out
echo textTest
./c- textTest.c- > output ; diff output textTest.out
