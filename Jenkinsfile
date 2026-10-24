pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Shell syntax') {
            steps {
                sh '''
                    set -eu
                    for file in runtime/*; do
                        case "$file" in
                            runtime/palorder-lua-host|runtime/palorder-version) continue ;;
                        esac
                        sh -n "$file"
                    done
                    sh -n install.sh
                    sh -n uninstall.sh
                '''
            }
        }

        stage('Lua syntax') {
            steps {
                sh '''
                    set -eu
                    if command -v luac5.4 >/dev/null 2>&1; then
                        luac5.4 -p runtime/palorder-lua-host
                    elif command -v luac >/dev/null 2>&1; then
                        luac -p runtime/palorder-lua-host
                    else
                        echo 'Lua compiler unavailable on this Jenkins agent; Lua syntax check skipped.'
                    fi
                '''
            }
        }

        stage('Installer contract') {
            steps {
                sh '''
                    set -eu
                    grep -Fq 'https://raw.githubusercontent.com/PalorderSoftWorksOfficial/Palorder-ish/main' install.sh
                    grep -Fq 'palorder-settings' install.sh
                    grep -Fq 'palorder-lua-host' install.sh
                    grep -Fq 'check-update' install.sh
                    grep -Fq 'lua5.4' install.sh
                    grep -Fq 'CORE_PACKAGES="bash dialog' install.sh
                    grep -Fq 'OPTIONAL_GROUPS=' install.sh
                    grep -Fq 'palorder-shell' install.sh
                    grep -Fq 'palorder-network' install.sh
                    grep -Fq 'palorder-history' install.sh
                    grep -Fq 'palorder-dev' install.sh
                    grep -Fq 'SHELL=/bin/bash' install.sh
                    grep -Fq '0.5.0' runtime/palorder-version
                    grep -Fq 'commits?per_page=20' runtime/palorder-history
                    grep -Fq 'api.window=' runtime/palorder-lua-host
                    grep -Fq 'api.ui.password=' runtime/palorder-lua-host
                    grep -Fq 'command -v ifconfig' runtime/palorder-network
                    grep -Fq 'pkg-compat apt' runtime/apt
                    grep -Fq 'pkg-compat pacman' runtime/pacman
                    grep -Fq 'apk update' install.sh
                    grep -Fq 'ensure_runtime' runtime/palorder-app
                    grep -Fq 'exec "$LUA_BIN" "$HOST" "$2"' runtime/palorder-app
                    for forbidden in 'AGENTS.md' 'README.md' 'CONTRIBUTING.md' 'SECURITY.md' 'Jenkinsfile' '.github'; do
                        if grep -Fq "$forbidden" install.sh; then
                            echo "Installer unexpectedly references development file: $forbidden" >&2
                            exit 1
                        fi
                    done
                    for file in palorder palorder-boot palorder-ui palorder-setup palorder-settings palorder-packages palorder-update palorder-run-task palorder-utilities palorder-terminal palorder-control palorder-lua-host palorder-app check-update palorder-version pkg-compat apt apt-get pacman palorder-shell palorder-network palorder-dev palorder-history palorder-changelog; do
                        test -s "runtime/$file"
                    done
                    test -s docs/LUA_APP_API.md
                '''
            }
        }

        stage('ShellCheck') {
            steps {
                sh '''
                    set -eu
                    if command -v shellcheck >/dev/null 2>&1; then
                        shellcheck -s sh install.sh uninstall.sh runtime/palorder runtime/palorder-app runtime/check-update runtime/palorder-control runtime/palorder-update runtime/pkg-compat runtime/apt runtime/apt-get runtime/pacman runtime/palorder-shell runtime/palorder-network runtime/palorder-dev runtime/palorder-history runtime/palorder-changelog
                    else
                        echo 'ShellCheck is not installed on this Jenkins agent; syntax checks passed, ShellCheck skipped.'
                    fi
                '''
            }
        }
    }

    post {
        success { echo 'Palorder iSH validation passed.' }
        failure { echo 'Palorder iSH validation failed. Review the stage logs above.' }
    }
}
