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
                    for file in runtime/*; do
                        sh -n "$file"
                    done
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
                    for forbidden in 'AGENTS.md' 'README.md' 'CONTRIBUTING.md' 'SECURITY.md' 'Jenkinsfile' '.github'; do
                        if grep -Fq "$forbidden" install.sh; then
                            echo "Installer unexpectedly references development file: $forbidden" >&2
                            exit 1
                        fi
                    done
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
