pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Shell syntax') {
            steps {
                sh '''
                    set -eu
                    find runtime -type f -exec sh -n {} \\;
                    sh -n install.sh
                    sh -n uninstall.sh
                '''
            }
        }

        stage('Installer contract') {
            steps {
                sh '''
                    set -eu
                    grep -Fq 'https://raw.githubusercontent.com/PalorderSoftWorksOfficial/Palorder-ish/main' install.sh
                    grep -Fq 'palorder-settings' install.sh
                    grep -Fq 'AGENTS.md' README.md
                    if grep -Eq 'AGENTS\\.md|README\\.md|CONTRIBUTING\\.md|SECURITY\\.md|Jenkinsfile|\\.github' install.sh; then
                        echo 'Installer must not include development files in its download allowlist.' >&2
                        exit 1
                    fi
                    for file in palorder palorder-boot palorder-ui palorder-setup palorder-settings palorder-packages palorder-update palorder-run-task palorder-utilities; do
                        test -s "runtime/$file"
                    done
                '''
            }
        }

        stage('ShellCheck') {
            steps {
                sh '''
                    set -eu
                    if command -v shellcheck >/dev/null 2>&1; then
                        shellcheck -s sh install.sh uninstall.sh runtime/*
                    else
                        echo 'ShellCheck is not installed on this Jenkins agent; syntax checks passed, ShellCheck skipped.'
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo 'Palorder iSH validation passed.'
        }
        failure {
            echo 'Palorder iSH validation failed. Review the stage logs above.'
        }
    }
}
