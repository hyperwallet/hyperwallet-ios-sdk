docs:
	@jazzy \
        --min-acl public \
        --no-hide-documentation-coverage \
        --theme fullwidth \
	--title HyperwalletSDK \
	--module HyperwalletSDK \
        --output ./docs \
        --documentation=./*.md
	@rm -rf ./build
