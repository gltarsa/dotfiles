0s** Converts a Daytimer ASCII export of fn,ln,op,hp,email into readable form *
/^"","",/!{
s/","/ /
}
/^"","",/s///g
/"",/s///g
/","/s//	/g
/"/s///g
