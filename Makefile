###################
# RELEASE ENV
##################
RELEASE_SUPPORT=.release/make-release-support
RELEASE_FILE=.release/release
VERSION=$(shell . $(RELEASE_SUPPORT) ; getVersion)
TAG=$(shell . $(RELEASE_SUPPORT); getTag)
SHA=$(shell git show-ref -s $(TAG))

#####################
# COMMON VALUES
#####################
SHELL=/bin/bash
V = 0
Q = $(if $(filter 1,$V),,@)
M = $(shell printf "\033[34;1m▶\033[0m")
MT = $(shell printf "  \033[36;1m▶\033[0m")
MT2 = $(shell printf "    \033[36;1m-\033[0m")

#####################
# TARGETS
#####################
default: .build version ; @ ## Default Task, build program with default values

version: .do-version ; @ ## Get current version

check-status: .do-check-status ; @ ## Check current git status

check-release: .do-check-release ; @ ## Check release status

major-release: .do-major-release ; @ ## Do a major-release, ie : bumped first digit X+1.y.z

minor-release: .do-minor-release ; @ ## Do a minor-release, ie : bumped second digit x.Y+1.z

patch-release: .do-patch-release ; @ ## Do a patch-release, ie : bumped third digit x.y.Z+1

precommit: .do-precommit ; @ ## Execute some checks with pre-commit hooks

help: .do-help ; @ ## Show this help (Run make <target> V=1 to enable verbose)

# =====================
# ====   BUILD    =====
# =====================
.build: .build-info .pre-build .do-build .post-build
.build-info: ; $(info $(M) Building...)

.pre-build:

.do-build: ; $(info $(MT) Nothing to build here.)

.post-build:

# =====================
# ====  RELEASES  =====
# =====================

# ===> Major
.do-major-release: .major-release-info .tag-major-release .do-release version
.major-release-info: ; $(info $(M) Do major release...)
.tag-major-release: VERSION := $(shell . $(RELEASE_SUPPORT); nextMajorLevel)
.tag-major-release: .release .tag

# ===> Minor
.do-minor-release: .minor-release-info .tag-minor-release .do-release version
.minor-release-info: ; $(info $(M) Do minor release...)
.tag-minor-release: VERSION := $(shell . $(RELEASE_SUPPORT); nextMinorLevel)
.tag-minor-release: .release .tag

# ===> Path
.do-patch-release: .patch-release-info .tag-patch-release .do-release version
.patch-release-info: ; $(info $(M) Do minor release...)
.tag-patch-release: VERSION := $(shell . $(RELEASE_SUPPORT); nextPatchLevel)
.tag-patch-release: .release .tag


# ===> INIT RELEASE FILE
.release:
	@echo "release=0.0.0" > $(RELEASE_FILE)
	@echo "tag=0.0.0" >> $(RELEASE_FILE)
	@echo INFO: $(RELEASE_FILE) created
	@cat $(RELEASE_FILE)

# ===> DO RELEASE
.do-release: check-status check-release

# ===> Do TAG
.tag: TAG=$(shell . $(RELEASE_SUPPORT); getTag $(VERSION))
.tag: check-status
	@. $(RELEASE_SUPPORT) ; ! tagExists $(TAG) || (echo "ERROR: tag $(TAG) for version $(VERSION) already tagged in git" >&2 && exit 1) ;
	@. $(RELEASE_SUPPORT) ; setRelease $(VERSION)
	sed -i -e "s/Release_version-.*-blue/Release_version-$(VERSION)-blue/g" README.md
	sed -i -e "s/\"version\": \".*\"/\"version\": \"$(VERSION)\"/g" package.json
	docker container run -it -v ${PWD}:/app --rm yvonnick/gitmoji-changelog:latest update $(VERSION)
	git add --all
	git commit -m ":bookmark: bumped to version $(VERSION)" ;
	git tag $(TAG) ;
	@ if [ -n "$(shell git remote -v)" ] ; then git push --tags ; else echo 'no remote to push tags to' ; fi
	git push

# ===> CHECK RELEASE
.do-check-release: ; $(info $(M) Checking release...)
	@. $(RELEASE_SUPPORT) ; tagExists $(TAG) || (echo "ERROR: version not yet tagged in git. make [minor,major,patch]-release." >&2 && exit 1) ;
	@. $(RELEASE_SUPPORT) ; ! differsFromRelease $(TAG) || (echo "ERROR: current directory differs from tagged $(TAG). make [minor,major,patch]-release." ; exit 1)


# =======================
# ===    COMMONS    =====
# =======================

# ===> Get current version
.do-version: ; $(info $(M) Current version)
	$(info $(MT) $(VERSION))

# ===> Check current repository status
.do-check-status:  ; $(info $(M) Checking git status...)
	@. $(RELEASE_SUPPORT) ; ! hasChanges || (echo "ERROR: there are still outstanding changes" >&2 && exit 1) ;

# ===> Run pre-commit
.do-precommit: ; $(info $(M) Checking pre-commit hooks...)
	pre-commit run -a

# ===> Help
.do-help:
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# ===========================================================================================

BUILD_TARGETS := pre-build do-build post-build build
REALEASE_TARGETS := check-release major-release  minor-release patch-release
INFO_TARGETS := version .do-version check-status .do-check-status
PRECOMMIT_TARGETS := precommit do-precommit
HELP_TARGETS :=  help .do-help

.PHONY: $(BUILD_TARGETS) $(RELEASE_TARGETS) $(INFO_TARGETS) $(PRECOMMIT_TARGETS) $(HELP_TARGETS)