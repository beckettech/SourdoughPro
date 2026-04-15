#!/bin/bash
# Hourly sourdough research cron job
# Continues research overnight to build comprehensive feature list

cd /home/beck/.openclaw/workspace

# Spawn a research session that continues the work
openclaw session spawn --task "Continue sourdough app research. Read sourdough-research.md to see what's been done. Pick ONE area to research deeply this hour:
1. Read App Store reviews for competitor apps (complaints = opportunities)
2. Research sourdough science (fermentation, yeast behavior, gluten development)
3. Explore bread baking forums for common questions/pain points
4. Research AI/ML techniques for food image analysis
5. Look into fermentation prediction algorithms

Update sourdough-research.md with findings. Focus on finding UNIQUE features we can build that solve real problems." --timeout 600 --channel discord
