#!/usr/bin/env sh
set -e

# Define redbot arguments
if [ -z "$INSTANCE_NAME" ]; then
    INSTANCE_NAME="RedBot"
fi

[ -z "$TOKEN" ] && echo "ERROR: Missing TOKEN environment variable" && exit 1
[ -z "$PREFIX" ] && echo "ERROR: Missing PREFIX environment variable" && exit 1

ARGS="$INSTANCE_NAME --token $TOKEN --prefix $PREFIX --no-prompt"

if [ "$RPC_ENABLED" = 'true' ]; then
    ARGS="$ARGS --rpc"

    if [ -z "$RPC_PORT" ]; then
        ARGS="$ARGS --rpc-port 6133"
    else
        ARGS="$ARGS --rpc-port $RPC_PORT"
    fi
fi

if [ "$TEAM_MEMBERS_ARE_OWNERS" = 'true' ]; then
    ARGS="$ARGS --team-members-are-owners"
fi

# Append any arguments passed from cmdline
[ -n "$EXTRA_ARGS" ] && echo "ERROR: EXTRA_ARGS is no longer supported. See https://github.com/rHomelab/Red-DiscordBot-Docker#additional-options" && exit 1
ARGS="$ARGS $@"

if [ -n "$PIP_REQUIREMENTS" ]; then
    echo "Installing pip packages: $PIP_REQUIREMENTS"
    python3 -m pip install --no-cache-dir --user $PIP_REQUIREMENTS
    echo
fi

# Ensure Red instance exists
echo "Checking for existing Red instances..."
if redbot --list-instances | grep -qe '^No instances have been configured!'; then
    echo "No Red instance found. Creating instance '$INSTANCE_NAME'..."

    {
        redbot-setup --instance-name "$INSTANCE_NAME" --no-prompt --data-path /redbot/data && \
        echo "Red instance '$INSTANCE_NAME' created successfully. Starting...\n"
    } || {
        echo "Failed to create Red instance '$INSTANCE_NAME'."
        exit 1
    }
else
    echo "Found Red instance '$INSTANCE_NAME'. Starting..."
fi

redbot $ARGS
