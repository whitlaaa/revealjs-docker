# revealjs-docker

Provides a simplified way to work on [RevealJS] slides via [Docker].

## Docker image

The provided Docker image is relatively simple, pulling down RevealJS and ultimately building a smaller image based off of `nginx:alpine`. This keeps the image size smaller at the expense of tools like livereload, etc.

## Project structure

The created image has some small customizations to make working on slides require less overhead:

* `index.html` pulls slides and your theme selection from a `presentation` directory:
  * `presentation/slides.md` is a single Markdown file for building your slides. This has the downside of requiring a single file for all slides, so it may not be ideal for complex presentations or those with a ton of slides.
  * `presentation/themes.html` is used as an HTML import and allows you to select from RevealJS' available slide deck [themes] (defaults to `black`)

## Creating a presentation

As mentioned above, slides and theme selection files MUST be placed in a `presentation` directory.

### Slide format

Slides follow the standard rules set by RevealJS, with the addition of vertical slides being separated by `--`. See the [sample slides] for more details.

### Theme selection

The `presentation/themes.html` file is about as simple as possible:

```html
<!-- Theme used for slides. Change `black` to another choice to change. -->
<link rel="stylesheet" href="../css/theme/black.css">

<!-- Theme used for syntax highlighting of code -->
<link rel="stylesheet" href="../lib/css/zenburn.css">
```

This project uses the default syntax highlighting theme of `zenburn`. If you choose to customize it , you will need to mount the desired theme files yourself.

### Using local images

If your presentation makes use of local images, you can reference those from wherever you'd like:

```markdown
![sample image](/presentation/images/sample.png)
```

Should you choose to use local image files, creating an `images` subdirectory inside of `presentations` makes it a bit simpler when mounting your
presenation files into the container. Further details below.

### Serving your slides

With the `presentation` directory in place, we can simply use Docker volume mounts to get our slides and customizations in place.

```shell
docker run -p 8080:80 -v /path/to/presentation/directory:/usr/share/nginx/html/presenation:ro whitlaaa/revealjs-docker
```

This will readonly mount your `presentation` directory into the appropriate location to be served by Nginx. Note that you can name your directory whatever you'd like, but it MUST be mounted as `presentation` when serving.

### Developing slides

With the container running, you can continue to modify your local `slides.md` and `themes.html` files as you see fit. Changes will be visible on browser refresh.

### Publishing slides

Once you're ready to publish your slides, you can easily copy the complete directory from the running container:

```shell
docker cp $CONTAINER_ID:/usr/share/nginx/html my-presentation-directory
```

Now just send `my-presentation-directory` to your favorite hosting provider and you're good to go!

[RevealJS]: https://github.com/hakimel/reveal.js/
[Docker]: https://www.docker.com
[Markdown]: https://github.com/hakimel/reveal.js/#markdown
[themes]: https://github.com/hakimel/reveal.js/#theming
[sample slides]: presentation/slides.md
