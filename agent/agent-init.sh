#!/bin/bash
# Runs at container start: set up the agent's browser, tools and desktop for the desktop user (abc).
HOME_DIR=/config
CHROME=$(ls -d /opt/pw-browsers/chromium-*/chrome-linux*/chrome 2>/dev/null | head -1)
PROFILE=$HOME_DIR/browser-profile
mkdir -p $HOME_DIR/.claude $HOME_DIR/workspace $HOME_DIR/Desktop $PROFILE

# Browser tool for Claude Code: persistent profile, so logins (Gmail etc.) are remembered.
cat > $HOME_DIR/.claude.json.mcp <<J
{"mcpServers":{"browser":{"command":"npx","args":["@playwright/mcp","--browser","chromium","--user-data-dir","$PROFILE"],"env":{"DISPLAY":":1","PLAYWRIGHT_BROWSERS_PATH":"/opt/pw-browsers"}}}}
J

# Desktop launcher: same browser + same profile, for the user to log into sites by hand.
cat > /usr/local/bin/algen-browser <<B
#!/bin/bash
pkill -f "user-data-dir=$PROFILE" 2>/dev/null; sleep 1
rm -f $PROFILE/SingletonLock $PROFILE/SingletonSocket $PROFILE/SingletonCookie
exec "$CHROME" --user-data-dir="$PROFILE" --no-sandbox --test-type --disable-gpu --disable-dev-shm-usage --no-first-run --no-default-browser-check "\${1:-https://mail.google.com}"
B
chmod +x /usr/local/bin/algen-browser
cat > $HOME_DIR/Desktop/algen-browser.desktop <<D
[Desktop Entry]
Type=Application
Name=Agent Browser (log in here)
Comment=Log into websites for this agent. Close it when done.
Exec=/usr/local/bin/algen-browser
Icon=web-browser
Terminal=false
D
chmod +x $HOME_DIR/Desktop/algen-browser.desktop

chown -R abc:abc $HOME_DIR/.claude $HOME_DIR/workspace $HOME_DIR/Desktop $PROFILE $HOME_DIR/.claude.json.mcp
