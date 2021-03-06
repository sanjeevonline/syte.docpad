<article id="{{ id }}">
	<hgroup>
		<h2><a href="/post/{{ id }}">{{ artist }} - {{ track_name }}</a></h2>
		<h3><a href="#{{ id }}">{{ date }}</a></h3>
	</hgroup>

	{{{ player }}}

	{{#if caption}}
		{{{ caption }}}
	{{/if}}

	<footer>
		{{#if tags }}
			<h4>Tags</h4>
			<ul class="tags">
				{{#each tags}}
					<li><a href="/tags/{{ this }}">{{ this }}</a></li>
				{{/each}}
			</ul>
		{{/if}}

		{{#if disqus_enabled }}
			<div id="disqus_thread" class="disqus-thread">
				<a href="/post/{{ id }}#disqus_thread" class="comments"></a>
			</div>
		{{/if}}
	</footer>
</article>
