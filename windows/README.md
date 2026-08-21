# Windows host config

Copies, not symlinks: Windows cannot follow a symlink that points into the WSL
filesystem, and the `dotfiles` ansible role only links the Linux side. Editing a
file here does nothing until it is copied across, in either direction.

Paths mirror the layout under `%USERPROFILE%`, so `.glzr/glazewm/config.yaml`
here is `%USERPROFILE%\.glzr\glazewm\config.yaml` there, and
`AppData/Local/rio/config.toml` is `%LOCALAPPDATA%\rio\config.toml`.

```sh
# pull the live Windows config back into the repo
L=/mnt/c/Users/$USER
cp "$L/AppData/Local/rio/config.toml" AppData/Local/rio/
cp "$L/.glzr/glazewm/config.yaml"     .glzr/glazewm/
```

## Rio

Rio replaced wezterm as the terminal on GlazeWM workspace N (see the `"N"` arm
of `.glzr/glazewm/glaze_launcher.ps1`). It draws kitty graphics with unicode
placeholders, which corc's browser view needs and wezterm ignores.

Two things the config cannot do by itself:

- `install-conpty.ps1` copies the ConPTY build rio needs into `C:\Program
  Files\Rio`. Without it the system ConPTY swallows the kitty graphics escapes
  coming out of WSL. The two binaries it copies are deliberately not in this
  repo; keep them in `%LOCALAPPDATA%\rio\conpty-backup`. Re-run the script after
  every `winget upgrade rio`.
- The `[bindings]` block restores Ctrl+Space, the tmux prefix, which rio 0.5.25
  does not send on Windows. The comment in `config.toml` has the details.
