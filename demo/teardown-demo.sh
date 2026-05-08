#!/bin/bash
# teardown-demo.sh — Remove the demo workspace cleanly

DEMO_DIR="$HOME/.openclaw/workspace-demo"

if [ ! -d "$DEMO_DIR" ]; then
  echo "Demo workspace not found at $DEMO_DIR — nothing to remove."
  exit 0
fi

echo "Removing demo workspace at $DEMO_DIR..."
rm -rf "$DEMO_DIR"
echo "✅ Demo workspace removed."
