#!/usr/bin/env bats

load test_helper

setup() {
	setup_test_env
}

@test "apply preserves existing top-level dotfiles and remains idempotent" {
	cat >"$HOME/.zshrc" <<'EOF'
alias mine="echo preserved"
EOF

	cat >"$HOME/.gitconfig" <<'EOF'
[credential]
    helper = osxkeychain
[user]
    name = Existing User
    email = existing@example.com
EOF

	run bash "$BATS_TEST_DIRNAME/../setup-my-mac.sh" --apply --profile core
	[ "$status" -eq 0 ]

	run bash "$BATS_TEST_DIRNAME/../setup-my-mac.sh" --apply --profile core
	[ "$status" -eq 0 ]

	assert_file_contains "$HOME/.zshrc" 'alias mine="echo preserved"'
	assert_file_contains "$HOME/.zshrc" "$HOME/.config/shellcraft/zshrc.zsh"
	assert_file_contains "$HOME/.gitconfig" "helper = osxkeychain"
	assert_file_contains "$HOME/.gitconfig" "path = ~/.config/shellcraft/gitconfig"
	[ "$(grep -c 'path = ~/.config/shellcraft/gitconfig' "$HOME/.gitconfig")" -eq 1 ]
	[ "$(grep -c "$HOME/.config/shellcraft/zshrc.zsh" "$HOME/.zshrc")" -eq 1 ]
}

@test "containers profile merges docker CLI plugin path safely" {
	mkdir -p "$HOME/.docker"
	cat >"$HOME/.docker/config.json" <<'EOF'
{"credsStore":"osxkeychain"}
EOF

	run bash "$BATS_TEST_DIRNAME/../setup-my-mac.sh" --apply --profile containers

	[ "$status" -eq 0 ]
	assert_file_contains "$HOME/.docker/config.json" '"credsStore": "osxkeychain"'
	assert_file_contains "$HOME/.docker/config.json" '"cliPluginsExtraDirs"'
	assert_file_contains "$HOME/.docker/config.json" "$HOME/homebrew/lib/docker/cli-plugins"
}
