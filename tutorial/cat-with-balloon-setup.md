## hi and welcome to cat with balloon!

Now on Minecraft 26.3. Mods update themselves every time you press Play.

* **First time here?** Go to [First time here](#first-time-here). About 10 minutes.
* **Already played on 26.2?** Go to [Updating from 26.2](#updating-from-262). About 5 minutes.

---

## First time here

A quick guide to get you logged on for the first time.

::: info
**You don't need a Mojang account.** Cat with balloon uses its own login server called Drasl, hosted next to the Minecraft server. You make an account there with just a username and password, and skins and all the normal features still work.

:::

::: warn
**You need a different launcher.** The normal Minecraft launcher can't log in to Drasl. Fjord Launcher can, and it also handles all the mods for you.

:::

### 1. Install Fjord Launcher

Download it here: [FjordLauncherUnlocked releases](https://github.com/hero-persson/FjordLauncherUnlocked/releases/latest)

On Windows, grab `FjordLauncher-Windows-MinGW-w64-Setup-….exe` and run it. The default options are fine. On Mac or Linux, pick the file for your system from the same page.

### 2. Make your Drasl account

Go to: [Drasl registration](https://homeium-v1.tailee6a47.ts.net:8443/)

Register with a username and password. The username is your in-game name.

### 3. Add the account to Fjord Launcher

Go to **Accounts → Manage Accounts → Add authlib-injector** and fill in:

| Field    | What to enter             |
|----------|---------------------------|
| Username | your Drasl username       |
| Password | your Drasl password       |
| URL      | `https://homeium-v1.tailee6a47.ts.net:8443/` |

### 4. Add the game

Download: [cat with balloon 26.3.zip](https://github.com/vicMJ/catwithballoon/raw/main/friend-instance/cat%20with%20balloon%2026.3.zip) (100 KB)

Drag the zip onto the Fjord Launcher window, or click **Add Instance → Import → Browse** and pick it. A new instance called **cat with balloon 26.3** appears.

### 5. Press Play

An **Updating modpack** window downloads 44 mods and 12 shaders. The first time takes a minute or two.

### 6. Join the server

Go to Multiplayer and join **cat with balloon [publicip]**. If you're on the Tailscale network, use the **[tailscaleip]** one instead.

If the list is empty, add the server by hand: `cwb.ddns.net`

---

## Updating from 26.2

You already have Fjord Launcher and an account, so you only need the new instance. Your Drasl login and your stuff on the server stay the same.

::: warn
**Don't update your old instance.** Leftover 26.2 mods in an old mods folder crash the game. Always import the new one.

:::

### 1. Import the new instance

Download: [cat with balloon 26.3.zip](https://github.com/vicMJ/catwithballoon/raw/main/friend-instance/cat%20with%20balloon%2026.3.zip) (100 KB)

Drag it onto Fjord Launcher, or **Add Instance → Import**. Don't launch it yet if you want to keep your settings.

### 2. Pick a path

#### Path A: Keep my settings

Your keybinds, video settings, mod options, minimap and waypoints come with you.

1. Right-click your **old** instance → **Folder**. Do the same for the **new** one, so both are open.
2. In the old one, open the `minecraft` folder and copy these into the new instance's `minecraft` folder:
   * `options.txt`: keybinds, video, sound
   * `config`: mod settings, including your shader choice
   * `xaero` and `XaeroWaypoints`: minimap, world map, waypoints
   * `screenshots` and `resourcepacks`, if you want them
3. Say yes if Windows asks to replace files.
4. **Never copy** `mods` or `shaderpacks`. The new instance gets its own.

#### Path B: Start fresh

Default settings, clean slate. Good if things felt broken or laggy before, or you just don't care.

1. Nothing to copy. Skip straight to the next step.
2. Your inventory, builds and waystones live on the server, so you don't lose any of that.
3. Your minimap waypoints and explored world map are saved on your PC, so those start empty. Use Path A if you want to keep them.

### 3. Press Play and join

The first launch downloads the mods (a minute or two). The server list comes with the new instance. Join **cat with balloon** as before.

### 4. Delete the old instance

Once everything works, right-click the old instance → **Delete**, so you don't launch it by accident.

---

## From now on

Just press Play. The update check runs every launch and only downloads what changed.

::: info
**Fine to do**

* Change any settings, keybinds or mod options. Updates never reset them.
* Pick a different shader in Iris.
* Add your own resource packs.
* Change memory: **Edit instance → Settings → Java** (6 GB by default).

:::

::: warn
**Don't do**

* Add, remove or update mods yourself, including the "Update" button on the launcher's Mods tab.
* Drop jars into the mods folder.
* Remove the pre-launch command in the instance settings. That's what keeps you updated.

:::

---

## If something goes wrong

**Can't log in, or "Invalid session" when joining**
Check that your account in Fjord Launcher is the authlib-injector one with the Drasl URL above, and that it's selected (top right of the launcher).

**The update window shows an error**
Check your internet and press Play again. If it keeps failing, screenshot the window and send it to Jorryn.

**"Incompatible mods" or version mismatch when joining**
The pack was probably updated while your game was open. Close Minecraft and press Play again.

**Crash after copying settings (Path A)**
Delete the `config` folder from the new instance and launch again. Mods recreate it with defaults; `options.txt` and your maps can stay.

**The game crashes on start**
Don't delete anything. Send Jorryn the crash report (**Edit instance → Minecraft Log**, or the `crash-reports` folder).

**The launcher asks which Java to use**
Pick Java 25, or let the launcher download it automatically.

---

Minecraft 26.3 · Fabric 0.19.5 · Pack source: [github.com/vicMJ/catwithballoon](https://github.com/vicMJ/catwithballoon)
