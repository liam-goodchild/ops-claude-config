# VS Code Setup

## Claude Terminal Profile

Adds Claude as an option in the VS Code terminal dropdown.

Add to `%APPDATA%\Code\User\settings.json`:

```json
"terminal.integrated.profiles.windows": {
    "Claude (Git Bash)": {
        "path": "C:\\Program Files\\Git\\bin\\bash.exe",
        "args": ["-c", "claude; exec bash"]
    }
}
```

Launches Claude on terminal open. Returns to bash shell on exit.

**Requires:** Git Bash installed at the default path.
