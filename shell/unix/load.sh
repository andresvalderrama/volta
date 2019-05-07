volta() {
    local EXIT_CODE
    local NOTION_ROOT

    # Use the user's existing `NOTION_HOME` environment value if set; otherwise,
    # use a default of `~/.volta`.
    NOTION_ROOT="${NOTION_HOME:-"$HOME/.volta"}"

	# Generate 32 bits of randomness, to avoid clashing with concurrent executions.
    export NOTION_POSTSCRIPT="${NOTION_ROOT}/tmp/volta_tmp_$(dd if=/dev/urandom count=1 2> /dev/null | cksum | cut -f1 -d" ").sh"

    # Forward the arguments to the Volta executable.
    NOTION_SHELL=bash command "${NOTION_ROOT}/volta" "$@"
    EXIT_CODE=$?

    # Call the post-invocation script if it is present, then delete it.
    # This allows the invocation to potentially modify the caller's environment (e.g., PATH).
    if [ -f "${NOTION_POSTSCRIPT}" ]; then
        . "${NOTION_POSTSCRIPT}"
        rm "${NOTION_POSTSCRIPT}"
    fi

    unset NOTION_POSTSCRIPT
    return $EXIT_CODE
}
