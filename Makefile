# Build the website. Two builds are necessary becase gulp will
# compile and remove unused css, second build will simply copy
# the new css file to docs directory
.PHONY : build
build:
	@jekyll build
	@gulp css
	@jekyll build

# Install needed components. Can't use Docker here because of phantomjs.
# Jekyll is locked at version 3, because that is the latest one 
# which supports redcarpet.
# gulp is required in both local and global context because "requirement".
.PHONY: setup
setup:
	@gem install --version 3.9.0 jekyll
	@gem install redcarpet jekyll-paginate
	@npm install
	@npm install -g "gulp"@"^4.0.2"

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
