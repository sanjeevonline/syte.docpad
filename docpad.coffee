# =================================
# Prepare

# Import
extendr = require('extendr')
moment = require('moment')

# Environment
envConfig = process.env


# =================================
# DocPad Configuration

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
module.exports =
	# =================================
	# DocPad Options

	# Regenerate Every
	# Performs a rengeraete every x milliseconds, useful for always having the latest data
	regenerateEvery: 60*60*1000 # hour


	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ
	templateData:

		# Extend
		extend: extendr.deepExtend.bind(extendr)

		# Moment
		moment: moment

		# Specify the theme we are using
		theme: "metro"

		# Specify some site properties
		site:
			# The production url of our website
			url: (websiteUrl = "http://your-website.com")

			# The default title of our website
			title: "Your Website"

			# The website author's name
			author: "Your Name"

			# The website author's email
			email: "b@lupton.cc"

			# The website heading to be displayed on the page
			heading: 'Your Website'

			# The website subheading to be displayed on the page
			subheading: """
				Welcome to your new <t>links.docpad</t> website!
				"""

			# Footer
			footnote: """
				This website was created with <t>links.bevry</t>’s <t>links.docpad</t>
				"""
			copyright: """
				Your chosen license should go here... Not sure what a license is? Refer to the <code>README.md</code> file included in this website.
				"""

			# The website description (for SEO)
			description: """
				When your website appears in search results in say Google, the text here will be shown underneath your website's title.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				place, your, website, keywoards, here, keep, them, related, to, the, content, of, your, website
				"""

			# Styles
			styles: [
				"/styles/styles.css"
				"/fonts/syte/css/syte.css"
			]

			# Scripts
			scripts: [
				"/vendor/jquery.js"
				"/vendor/log.js"
				"/vendor/modernizr.js"
				"/scripts/script.js"
			]

			# Specify some feeds available for the visitors of our website
			feeds: [
					# This is the feed generated by our DocPad website
					# It contains all the posts, you can find the source file in src/documents/atom.xml.eco
					href: "#{websiteUrl}/atom.xml"
					name: 'Blog Posts'
			]

			# Do you have social accounts?
			# Mention them here and our layout will include them in the sidebar
			# If you specify a feed for the Feedr plugin (specified later on)
			# then we will pull in their feed data too for recognised services
			social:
				# Twitter
				twitter:
					name: 'Twitter'
					url: "https://twitter.com/#{envConfig.TWITTER_USERNAME}"
					#profile:
					#	feeds:
					#		tweets: 'twitter'

				# GitHub
				github:
					name: 'GitHub'
					url: "https://github.com/#{envConfig.GITHUB_USERNAME}"
					profile:
						feeds:
							user: 'githubUser'
							repos: 'githubRepos'

				# Vimeo
				vimeo:
					name: 'Vimeo'
					url: "https://vimeo.com/#{envConfig.VIMEO_USERNAME}"

				# Flickr
				flickr:
					name: 'Flickr'
					url: "http://www.flickr.com/people/#{envConfig.FLICKR_USER_ID}"
					profile:
						feeds:
							user: 'flickrUser'
							photos: 'flickrPhotos'

				# Soundcloud
				soundcloud:
					name: 'Soundcloud'
					url: "http://soundcloud.com/#{envConfig.SOUNDCLOUD_USERNAME}"
					profile:
						feeds:
							user: 'soundcloudUser'
							tracks: 'soundcloudTracks'

				# Instagram
				instagram:
					name: 'Instagram'
					url: "http://instagram.com/#{envConfig.INSTAGRAM_USER_ID}"
					profile:
						feeds:
							user: 'instagramUser'
							media: 'instagramMedia'


		# -----------------------------
		# Common links used throughout the website

		links:
			docpad: '<a href="https://github.com/bevry/docpad" title="Visit on GitHub">DocPad</a>'
			historyjs: '<a href="https://github.com/balupton/history.js" title="Visit on GitHub">History.js</a>'
			bevry: '<a href="http://bevry.me" title="Visit Website">Bevry</a>'
			opensource: '<a href="http://en.wikipedia.org/wiki/Open-source_software" title="Visit on Wikipedia">Open-Source</a>'
			html5: '<a href="http://en.wikipedia.org/wiki/HTML5" title="Visit on Wikipedia">HTML5</a>'
			javascript: '<a href="http://en.wikipedia.org/wiki/JavaScript" title="Visit on Wikipedia">JavaScript</a>'
			nodejs: '<a href="http://nodejs.org/" title="Visit Website">Node.js</a>'
			author: '<a href="http://balupton.com" title="Visit Website">Benjamin Lupton</a>'
			cclicense: '<a href="http://creativecommons.org/licenses/by/3.0/" title="Visit Website">Creative Commons Attribution License</a>'
			mitlicense: '<a href="http://creativecommons.org/licenses/MIT/" title="Visit Website">MIT License</a>'
			contact: '<a href="mailto:b@bevry.me" title="Email me">Email</a>'


		# -----------------------------
		# Helper Functions

		# Get Gravatar URL
		getGravatarUrl: (email,size) ->
			hash = require('crypto').createHash('md5').update(email).digest('hex')
			url = "http://www.gravatar.com/avatar/#{hash}.jpg"
			if size then url += "?s=#{size}"
			return url

		# Get Profile Feeds
		getSocialFeeds: (socialID) ->
			feeds = {}
			for feedID,feedKey of @site.social[socialID].profile.feeds
				feeds[feedID] = @feedr.feeds[feedKey]
			return feeds

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		# For instance, this one will fetch in all documents that have pageOrder set within their meta data
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		# This one, will fetch in all documents that have the tag "post" specified in their meta data
		posts: (database) ->
			database.findAllLive({tags: $has: 'post'}, [date:-1])


	# =================================
	# Plugin Configuration
	# This is where we configure the different plugins that are loaded with DocPad
	# To configure a plugin, specify it's name, and then the options you want to configure it with

	plugins:

		# Tumblr
		tumblr:
			extension: '.html.eco'
			injectDocumentHelper: (document) ->
				document.setMeta(
					layout: 'page'
					tags: (document.get('tags') or []).concat(['post'])
					data: """
						<%- @partial('content/'+@document.tumblr.type, @extend({}, @document, @document.tumblr)) %>
						"""
				)

		# Tags
		tags:
			extension: '.html.eco'
			injectDocumentHelper: (document) ->
				document.setMeta(
					layout: 'page'
					data: """
						<%- @partial('content/tag', @) %>
						"""
				)

		# Configure the Feedr Plugin
		# The Feedr Plugin will pull in remote feeds specified here and make their contents available to our templates
		feedr:

			# These are the feeds that Feedr will pull in
			feeds:
				# Twitter
				# twitter: url: "https://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{envConfig.TWITTER_USERNAME}&count=50&include_entities=false&include_rts=false&exclude_replies=true"

				# Github
				githubUser: url: "https://api.github.com/users/#{envConfig.GITHUB_USERNAME}?client_id=#{envConfig.GITHUB_CLIENT_ID}&client_secret=#{envConfig.GITHUB_CLIENT_SECRET}"
				githubRepos: url: "https://api.github.com/users/#{envConfig.GITHUB_USERNAME}/repos?sort=updated&client_id=#{envConfig.GITHUB_CLIENT_ID}&client_secret=#{envConfig.GITHUB_CLIENT_SECRET}"

				# Vimeo
				vimeo: url: "http://vimeo.com/api/v2/#{envConfig.VIMEO_USERNAME}/videos.json"

				# Flickr
				flickrUser:
					url: "http://api.flickr.com/services/rest/?method=flickr.people.getInfo&api_key=#{envConfig.FLICKR_API_KEY}&user_id=#{envConfig.FLICKR_USER_ID}&format=json&nojsoncallback=1"
					clean: true
				flickrPhotos: url: "http://api.flickr.com/services/feeds/photos_public.gne?id=#{envConfig.FLICKR_USER_ID}&lang=en-us&format=json&nojsoncallback=1"

				# Soundcloud
				soundcloudUser: url: "https://api.soundcloud.com/users/#{envConfig.SOUNDCLOUD_USERNAME}.json?client_id=#{envConfig.SOUNDCLOUD_CLIENT_ID}"
				soundcloudTracks: url: "https://api.soundcloud.com/users/#{envConfig.SOUNDCLOUD_USERNAME}/tracks.json?client_id=#{envConfig.SOUNDCLOUD_CLIENT_ID}"

				# Instagram
				instagramUser: url: "https://api.instagram.com/v1/users/#{envConfig.INSTAGRAM_USER_ID}?client_id=#{envConfig.INSTAGRAM_CLIENT_ID}"
				instagramMedia: url: "https://api.instagram.com/v1/users/#{envConfig.INSTAGRAM_USER_ID}/media/recent?access_token=#{envConfig.INSTAGRAM_ACCESS_TOKEN}"
