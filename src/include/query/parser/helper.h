/*
	The helper function for parser.
	Path: include/query/parser/helper.h
*/
#ifndef __SCAN_HELPER_H__
#define __SCAN_HELPER_H__

extern char *scanstr(const char *s);

extern char *downcase_truncate_identifier(const char *ident, int len,
							 bool warn);

extern char *downcase_identifier(const char *ident, int len,
					bool warn, bool truncate);

extern void truncate_identifier(char *ident, int len, bool warn);

extern bool scanner_isspace(char ch);

#endif							/*__SCAN_HELPER_H__ */

