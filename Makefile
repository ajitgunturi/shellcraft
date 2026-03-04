PROFILE ?= core
WITH_FONTS ?= 0
SET_DEFAULT_SHELL ?= 0
ALLOW_GUI_INSTALLS ?= 0

SCRIPT := ./setup-my-mac.sh
PROFILE_ARGS = $(strip $(foreach profile,$(subst $(comma), ,$(PROFILE)),--profile $(profile)))
OPTIONAL_FLAGS = $(if $(filter 1,$(WITH_FONTS)),--with-fonts,) \
	$(if $(filter 1,$(SET_DEFAULT_SHELL)),--set-default-shell,) \
	$(if $(filter 1,$(ALLOW_GUI_INSTALLS)),--allow-gui-installs,)
comma := ,

.DEFAULT_GOAL := help

.PHONY: help plan preview install apply doctor fix validate-profile

help:
	@printf '%s\n' \
		'Shellcraft' \
		'' \
		'Start here:' \
		'  make plan PROFILE=core' \
		'  make install PROFILE=core' \
		'  make doctor PROFILE=core' \
		'  make fix PROFILE=core' \
		'' \
		'Examples:' \
		'  make install PROFILE=core,backend' \
		'  make install PROFILE=containers WITH_FONTS=1 SET_DEFAULT_SHELL=1' \
		'' \
		'Profiles:' \
		'  core backend ai maintainer containers local-ai' \
		'' \
		'Notes:' \
		'  make is the user-facing local wrapper' \
		'  task is for maintainers and repo checks' \
		'  ./setup-my-mac.sh remains available for advanced/direct use'

validate-profile:
	@if [ -z "$(strip $(PROFILE))" ]; then \
		echo "PROFILE cannot be empty; use PROFILE=core or omit it"; \
		exit 1; \
	fi

plan: validate-profile
	@$(SCRIPT) --plan $(PROFILE_ARGS) $(OPTIONAL_FLAGS)

preview: plan

install: validate-profile
	@$(SCRIPT) --apply $(PROFILE_ARGS) $(OPTIONAL_FLAGS)

apply: install

doctor: validate-profile
	@$(SCRIPT) --doctor $(PROFILE_ARGS) $(OPTIONAL_FLAGS)

fix: validate-profile
	@$(SCRIPT) --doctor --fix $(PROFILE_ARGS) $(OPTIONAL_FLAGS)
