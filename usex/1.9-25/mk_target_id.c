/*  Copyright (c) David Anderson 1996, 1997, 1998, 1999, 2000, 2001, 2002 */

/*
 *  mk_target_id.c
 *
 *  CVS: $Revision$ $Date$
 */

#include "defs.h"

int
main(int argc, char **argv)
{
	printf("char *build_target_id = \"%s USEX_VERSION %s\";\n",
		MACHINE_TYPE, USEX_VERSION);	

	exit(0);
}

