0s**	Convert VT100 esc sequences, like the ones in VTX mailed items, *
0s**	into ASCII text.                                                *
0s**    - Greg Tarsa, Jan 1997                                          *
/[()]./s///g
/\[../s///g
/ x/{
	s/ x/|/g
	s/x/|/g
}
/[]/s///g
/[ 	]*$/s///g
/[lm]qqqq/{
	s/qk$/k/
	s/qj$/j/
	s/[lm]q/+-/g
	s/q[kj]/-+/g
	s/qj/+-/g
	s/q/-/g
	s/[wv]/+/g
}
