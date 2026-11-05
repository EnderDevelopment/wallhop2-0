# Roblox Wall-Hop Script

Wallhop2.0 is a client-side Roblox script that adds wall hop movement to a character. While airborne, the player can use the standard jump input near a sufficiently vertical wall to launch away from it and upward, making it a Roblox wall-hop controller script for keyboard, controller, and mobile jump input.

## Install

1. Open Roblox Studio and create or open your place.
2. In Explorer, open `StarterPlayer`, then `StarterPlayerScripts`.
3. Insert a `LocalScript` and name it `WallHop`.
4. Copy the contents of `src/WallHop.client.lua` into the LocalScript.
5. Start a test session with **Play**.

## Use

1. Make the character jump or enter freefall.
2. Move close to a vertical wall.
3. Press the normal jump input while the character is airborne.
4. If a nearby wall is detected, the character launches away from the wall and upward.

The script checks for walls in front of, behind, and to either side of the character. Floors and steep slopes are ignored. Character respawns are handled automatically.

Movement values can be adjusted at the top of `WallHop.client.lua`:

- `WALL_CHECK_DISTANCE`: maximum wall detection distance.
- `WALL_JUMP_COOLDOWN`: minimum time between wall hops.
- `WALL_JUMP_HORIZONTAL_SPEED`: horizontal launch speed away from the wall.
- `WALL_JUMP_VERTICAL_SPEED`: upward launch speed.
- `WALL_JUMP_DURATION`: duration of the launch force.
- `WALL_NORMAL_Y_LIMIT`: surface-angle filter used to ignore floors and steep slopes.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/75e2863d-50a6-48db-8ae1-2ba2a99f05a6?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=75e2863d-50a6-48db-8ae1-2ba2a99f05a6
