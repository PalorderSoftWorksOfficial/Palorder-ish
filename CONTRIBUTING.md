# Contributing

1. Discuss substantial changes in an issue before implementation.
2. Keep runtime scripts POSIX-shell compatible with Alpine BusyBox ash.
3. Prefer focused changes and explain iSH-specific assumptions.
4. Do not add secrets, personal configuration, or development files to the installer payload.
5. Test changed scripts with sh -n and run ShellCheck when available.
6. Update the README when commands, paths, requirements, or behavior change.

Pull requests should include a summary, testing performed, and known limitations.
