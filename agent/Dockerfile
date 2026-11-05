# Algen Bot agent computer: Linux desktop (viewable in browser) + Claude Code
FROM lscr.io/linuxserver/webtop:ubuntu-xfce

ENV PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
      curl ca-certificates git jq xdotool scrot imagemagick wmctrl python3 python3-pip \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @anthropic-ai/claude-code@2 @playwright/mcp@0 \
    && npx -y playwright@1 install-deps chromium \
    && cd /tmp && npx -y @playwright/mcp@0 install-browser chrome-for-testing \
    && chmod -R a+rx /opt/pw-browsers \
    && rm -rf /var/lib/apt/lists/*

COPY agent-init.sh /custom-cont-init.d/50-algenbot
RUN chmod +x /custom-cont-init.d/50-algenbot
