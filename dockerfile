# Use an Ubuntu base image with X11 layers pre-installed to save build time
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install core graphic drivers, audio engines, web tools, and full browser components
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    openbox \
    novnc \
    websockify \
    chromium-browser \
    curl \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Expose our unblocked ChromeOS interface port
EXPOSE 8006

# Command: Creates a virtual monitor, launches browser window, streams over port 8006
CMD ["bash", "-c", "Xvfb :1 -screen 0 1280x800x24 & export DISPLAY=:1 && openbox-session & x11vnc -forever -shared -display :1 -rfbport 5901 & websockify --web=/usr/share/novnc/ 8006 localhost:5901 & chromium-browser --no-sandbox --start-maximized --disable-gpu"]
