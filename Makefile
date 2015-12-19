# Build the website. Two builds are necessary becase gulp will
# compile and remove unused css, second build will simply copy
# the new css file to public directory
.PHONY : build
build:
	@jekyll build
	@gulp
	@jekyll build

# Build and publish changes. This will push source changes
# to source branch and built website to master branch.
.PHONY : deploy
deploy: build
	@git add .
	@git commit
	@git branch -D master
	@git checkout -b master
	@git filter-branch --subdirectory-filter public/ -f
	@git checkout source
	@git push --all --force-with-lease origin

# Clean out everything and start from scratch
.PHONY : setup
setup:
	@rm -rf node_modules/
	@rm -rf public/
	@npm install

# Create a new scratch post and initialise it with front matter
.PHONY : post
post:
	@read -e -p "  ==> Enter a title for new post: " title;                                                                                                       \
	title=$$(gsed -e 's/  */ /g' <<< $$title | tr -d '\n');                                                                                                       \
	echo "        Creating post with title - "$$title;                                                                                                            \
	ds=$$(date +"%Y-%m-%d");                                                                                                                                      \
	echo "        Creation date            - "$$ds;                                                                                                               \
	post=$$(tr '[:upper:]' '[:lower:]' <<< $$title  | tr -cd '[:alnum:][:blank:]' | gsed -e 's/ /-/g; s/  */ /g');                                                \
	echo "        Post URI                 - /post/"$$post;                                                                                                       \
	file=$$(gsed -e 's/^/'$$ds'-/' -e 's/$$/.markdown/' <<< $$post);                                                                                              \
	echo "        Creating file            - _posts/"$$file;                                                                                                      \
	gsed -e 's/#layout#/post_simple/' -e 's/#title#/'"$$title"'/' -e 's/#permalink#/post\/'"$$post"'/' -e 's/#date#/'"$$ds"'/' < _scaffold.md > _posts/$$file;    \
	$$EDITOR _posts/$$file
