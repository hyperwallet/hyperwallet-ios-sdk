docs:
	@jazzy \
        --min-acl public \
        --no-hide-documentation-coverage \
        --theme fullwidth \
        --output ./docs \
        --documentation=./*.md
	@rm -rf ./build
