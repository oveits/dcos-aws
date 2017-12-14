
PATH="/d/veits/downloads/DCOS CLI:$PATH"
ADMIN_CONSOLE=$(sh 4_print_admin_console_dns)
dcos cluster setup http://$ADMIN_CONSOLE
